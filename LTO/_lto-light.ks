run kesalib.
SET DIRHDG TO 90.
SET DIRAP TO 90000.
SET STARTYEAR TO 1.
SET STARTDAY TO 211.
SET STARTHOUR TO 0.
SET STARTMIN TO 35.
SET STARTSEC TO 10.
SET SRB_STAGE TO 0.
SET LIFT_STAGE TO 2.
SET PRELAUNCH_STG TO 1.
SET FAIR_SEP_HEIGHT TO 51000.
SET COM_SWITCH_HEIGHT TO 60000.
SET CNTDWN TO 2.	
SET SIMRUN TO 1.
set gt0 to 150.	
set gt1 to 40000.
set maxq to 7000.
SET LCTL_END TO 0.		
SET END_PROGRAM TO 0.
set euler to 2.718281828.
set pi to 3.1415926535.
set pitch to 0.
set pitch0 to 0.
set pitch1 to 90.
run lctl.
WAIT UNTIL LCTL_END = 1.
SET TSET to 1.
LOCK THROTTLE TO TSET.
PrtLog("DELETING LCTL FROM MEMORY").
deletepath("1:/lctl").
PrtLog(SHIP:NAME +" LIFTED OFF!").
PrtLog(SHIP:NAME +"`s TARGETTED ORBIT IS "+DIRAP +" METERS HEIGHT").
PrtLog(SHIP:NAME +"`s TARGETED INCLINATION IS "+DIRHDG).
run bodyprops.
PrtLog("TURNING ON STABLITY ASSIST UNTIL "+gt0 +"m").
SAS ON.
WHEN SHIP:ALTITUDE > FAIR_SEP_HEIGHT THEN {
	PrtLog("FAIRING SEPERATION").
	set p_fairing to ship:partsnamed("fairingSize1")[0].
	set m_fairing to p_fairing:getmodule("ModuleProceduralFairing").
	m_fairing:doevent("deploy").
}.
WHEN SHIP:ALTITUDE > COM_SWITCH_HEIGHT THEN {
	PrtLog("ENABLING COM SYSTEMS").
	set RT_AN1 to SHIP:PARTSNAMED("longAntenna")[0].
	SET RT_AN_MOD1 to RT_AN1:GETMODULE("ModuleRTAntenna").
	RT_AN_MOD1:DOEVENT("activate").
	set RT_AN2 to SHIP:PARTSNAMED("RTShortAntenna1")[0].
	SET RT_AN_MOD2 to RT_AN2:GETMODULE("ModuleRTAntenna").
	RT_AN_MOD2:DOEVENT("deactivate").
}.
WHEN STAGE:SOLIDFUEL < 1 AND SRB_STAGE > 0 THEN {
	PrtLog("REMAINING SRB FUEL: "+STAGE:SOLIDFUEL).
	PrtLog("SRB DECOUPLE").
	SET SRB_STAGE TO SRB_STAGE -1.
	PrtLog("REMAINING SRB STAGES: "+SRB_STAGE).
	STAGE.
}.
WHEN SHIP:MAXTHRUST < 0.1 AND LIFT_STAGE > 0 THEN {
	PrtLog("LIQ.FUEL END - STAGING").
	STAGE.
	PrtLog("STARTING NEXT ENGINE").
	WAIT 1.
	STAGE.
	SET LIFT_STAGE TO LIFT_STAGE -1.
	PrtLog("REMAINING LIFT STAGES: "+LIFT_STAGE).
	PRESERVE.
	}.
WHEN ALTITUDE > gt0 -1 THEN {
PrtLog("TURN OFF STABILITY ASSIST - CONTROLL TO kOS").
SAS OFF.
}.
until altitude > ha or apoapsis > DIRAP {
PrtMissParam().
    set ar to alt:radar.
    if ar > gt0 and ar < gt1 {
	set pitch to (90*(((cos(((ar - gt0)/(gt1 - gt0))*180)+1)/2)-1))+90.
	lock steering to HEADING(DIRHDG,pitch).
    }
    if ar > gt1 {
	lock steering to HEADING(DIRHDG,pitch).
    }
    set vsm to velocity:surface:mag.
    set exp to -altitude/sh.
    set ad to ad0 * euler^exp. 
    set q to 0.5 * ad * vsm^2.
    print round(q)+"  " at (56,3).
    set vl to maxq*0.9.
    set vh to maxq*1.1.
    if q < vl { set tset to 1. }
    if q > vl and q < vh { set tset to (vh-q)/(vh-vl). }
    if q > vh { set tset to 0. }
    wait 0.1.
}
set tset to 0.
if altitude < ha {
    PrtLog("WAITING TO LEAVE ATMOSPHERE").
    lock steering to HEADING(DIRHDG,pitch).
    until altitude > ha {
	PrtMissParam().
        if apoapsis >= DIRAP { set tset to 0. }
        if apoapsis < DIRAP { set tset to (DIRAP-apoapsis)/(DIRAP*0.01). }
        wait 0.1.
    }
}.
lock throttle to 0.
PrtLog("Apoapsis maneuver, orbiting " + body:name).
PrtLog("Apoapsis: " + round(apoapsis/1000) + "km").
Prtlog("Periapsis: " + round(periapsis/1000) + "km -> " + round(DIRAP/1000) + "km").
set vom to velocity:orbit:mag. 
set r to rb + altitude.       
set raa to rb + apoapsis.    
set va to sqrt( vom^2 + 2*mu*(1/raa - 1/r) ). 
set a to (periapsis + 2*rb + apoapsis)/2.
set r2 to rb + apoapsis.   
set a2 to (DIRAP + 2*rb + apoapsis)/2.
set v2 to sqrt( vom^2 + (mu * (2/r2 - 2/r + 1/a - 1/a2 ) ) ).
set deltav to v2 - va.
PrtLog("APOAPSIS BURN: " + round(va) + ", DV:" + round(deltav) + " -> " + round(v2) + "m/s").
set nd to node(time:seconds + eta:apoapsis, 0, 0, deltav).
add nd.
PrtLog("NODE CREATED").
set nd to nextnode.
PrtLog("Node apoapsis: " + round(nd:orbit:apoapsis/1000,2) + "km, periapsis: " + round(nd:orbit:periapsis/1000,2) + "km").
PrtLog("NODE in: " + round(nd:eta) + ", DeltaV: " + round(nd:deltav:mag)).
set maxa to maxthrust/mass.
set dob to nd:deltav:mag/maxa.   
PrtLog(" MAX ACC: " + round(maxa) + "M/S^2, BURN DURATION: " + round(dob) + "S").
PrtLog("Turning ship to burn direction.").
sas off.
rcs off.
set np to R(0,0,0) * nd:deltav.
lock steering to np.
until abs(np:direction:pitch - facing:pitch) < 0.1 and abs(np:direction:yaw - facing:yaw) < 0.1 {
PrtMissParam().
wait 0.1.
}.
UNTIL nd:eta <= (dob/2) {
PrtMissParam().
wait 0.1.
}.
PrtLog("ORBITAL BURN START " + round(nd:eta) + "S BEFORE APOAPSIS.").
set tset to 0.
lock throttle to tset.
set np to R(0,0,0) * nd:deltav.
lock steering to np.
set done to False.
set once to True.
set dv0 to nd:deltav.
until done {
   PrtMissParam().
    set maxa to maxthrust/mass.
    set tset to min(nd:deltav:mag/maxa, 1).
    if once and tset < 1 {
	PrtLog("Throttling down, remain dv " + round(nd:deltav:mag) + "m/s, fuel:" + round(stage:liquidfuel)).
        set once to False.
    }
    if vdot(dv0, nd:deltav) < 0 {
       PrtLog("End burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1)).
        lock throttle to 0.
        break.
    }
    if nd:deltav:mag < 0.1 {
        PrtLog("Finalizing, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1)).
        wait until vdot(dv0, nd:deltav) < 0.5.
        lock throttle to 0.
        PrtLog("End burn, remain dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1)).
        set done to True.
    }
}
unlock steering.
PrtLog("APOAPSIS: " + round(apoapsis/1000,2) + "KM, PERIAPSIS: " + round(periapsis/1000,2) + "KM").
PrtLog("FUEL AFTER BURN: " + round(stage:liquidfuel)).
wait 1.
remove nd.
PrtLog("PROGRAM FINISHED").
SET END_PROGRAM TO 1.
WAIT UNTIL END_PROGRAM =1. 
PrtLog("DELETING LTO FROM MEMORY").
deletepath("1:/lto").
