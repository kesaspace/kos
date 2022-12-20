// LAUNCH TO ORBIT
// LAUNCHSCRIPT ALL IN ONE FOR KEerbin Space Agency
// Notes: 
//
// For Launch Escape System: name decoupler for Launch Escape System: LES_Decoupler

run kesalib.
run mission.

// LV PARAMETERS ARE IN BOOT FILE NOW.
//ADDITIONAL PARAMETER FOR LAUNCH
SET FAIR_SEP_HEIGHT TO 55000.		// FAIRING SEPERATION HEIGHT
SET COM_SWITCH_HEIGHT TO 60000. 	// HEIGHT FOR SWITCH COM SYSTEMS


// GRAV TURN PARAMETERS
set gt0 to 150.						// FIRST HEIGHT FOR DECISION
set gt1 to 55000.
set maxq to 5000.					// MAX Q

// END OF SETTINGS

// INTERNAL PARAMETER - DO NOT CHANGE

// GENERAL PARAMETERS
SET LCTL_END TO 0.					// SET LAUNCH CTRL TO 0
SET END_PROGRAM TO 0.

//MATH PARAMETER
set euler to 2.718281828.
set pi to 3.1415926535.
//GRAV TURN PARAMETERS PART II
set pitch to 0.
set pitch0 to 0.
set pitch1 to 90.					// (www) NOT THE HEADING
//set config:safe to False. 		// (www) JUST IN CASE

// START COUNTDOWN AND RUN
run lctl.
WAIT UNTIL LCTL_END = 1.
SET TSET to 1.
LOCK THROTTLE TO TSET.
PrtLog("DELETING LCTL FROM MEMORY").
deletepath("1:/lctl").
run bodyprops.
PrtLog(SHIP:NAME +" LIFTED OFF!").
IF DEFINED LV_BOOTFILE {
	PrtLog("Bootfile "+LV_BOOTFILE+" loaded").
}
PrtLog(" -- PARAMETER FROM BOOTFILE --").
PrtLog("SRB STAGES:        "+SRB_STAGE).
PrtLog("LIFTING STAGES:    "+LIFT_STAGE).
IF LV_PCS = 1 {
PrtLog("PCS SYSTEM ENABLED").
PrtLog("PCS STAGES:        "+LV_PCS_STAGE).
}.
PrtLog(" -- MISSION PARAMETER --").
PrtLog(SHIP:NAME +"`s TARGETTED ORBIT IS "+DIRAP).
PrtLog(SHIP:NAME +"`s TARGETED HEADING IS "+DIRHDG).
IF DIRHDG = 90 {
PrtLog(SHIP:NAME +"`s TARGETED INCLINATION IS 0").
}.
IF DIRHDG < 90 {
SET TARGETINC TO 90 - DIRHDG.
PrtLog(SHIP:NAME +"`s TARGETED INCLINATION IS "+TARGETINC).
}.
IF DIRHDG > 90 {
SET TARGETINC TO DIRHDG -90.
PrtLog(SHIP:NAME +"`s TARGETED INCLINATION IS "+TARGETINC).
}.
PrtLog(SHIP:NAME +"`s FAIRING SEPERATING AT "+FAIR_SEP_HEIGHT).
PrtLog(SHIP:NAME +"`s SWITCH COM SYSTEMS AT "+COM_SWITCH_HEIGHT).
.


PrtLog("TURNING ON STABLITY ASSIST UNTIL "+gt0 +"m").
SAS ON.

// DEPLOYING FAIRING
WHEN SHIP:ALTITUDE > FAIR_SEP_HEIGHT AND LV_FAIRING = 1 THEN {
	PrtLog("FAIRING SEPERATION").
	IF DEFINED LV_FAIRING_TYPE {
		set p_fairing to ship:partsnamed(LV_FAIRING_TYPE)[0].
	}
	else 
	{
		set p_fairing to ship:partsnamed("fairingSize1")[0].
	}
	set m_fairing to p_fairing:getmodule("ModuleProceduralFairing").
	m_fairing:doevent("deploy").
}.

//SEPERATIING LAUNCH ESCAPE SYSTEM
WHEN SHIP:ALTITUDE > FAIR_SEP_HEIGHT AND LV_ESCAPE = 1 THEN {
	PrtLog("JETTISON LAUNCH ESCAPE SYSTEM").
	set p_lescape to ship:partsnamed("LaunchEscapeSystem")[0].
	set m_lescape to p_lescape:getmodule("ModuleEnginesFX").
	m_lescape:doevent("activate engine").
	set p_lescapesep to ship:partstagged("LES_Decoupler")[0].
	set m_lescapesep to p_lescapesep:getmodule("ModuleDecouple").
	m_lescapesep:doevent("decouple").
	}.

// SWITCHING COM-SYSTEM TO PAYLOAD
WHEN SHIP:ALTITUDE > COM_SWITCH_HEIGHT AND LV_ANTENNA = 1 THEN {
	PrtLog("ENABLING COM SYSTEMS").
	set RT_AN1 to SHIP:PARTSNAMED("longAntenna")[0].
	SET RT_AN_MOD1 to RT_AN1:GETMODULE("ModuleRTAntenna").
	RT_AN_MOD1:DOEVENT("activate").
	set RT_AN2 to SHIP:PARTSNAMED("RTShortAntenna1")[0].
	SET RT_AN_MOD2 to RT_AN2:GETMODULE("ModuleRTAntenna").
	RT_AN_MOD2:DOEVENT("deactivate").
}.

// DECOUPLE SRB
WHEN STAGE:SOLIDFUEL < 0.5 AND SRB_STAGE > 0 THEN {
	PrtLog("REMAINING SRB FUEL: "+STAGE:SOLIDFUEL).
	PrtLog("SRB DECOUPLE").
	SET SRB_STAGE TO SRB_STAGE -1.
	PrtLog("REMAINING SRB STAGES: "+SRB_STAGE).
	STAGE.
}.

// SEPERATING PROPELLANT CROSSFEED SYSTEM (PCS aka ASPARAGUS BOOSTER).
WHEN STAGE:LIQUIDFUEL < 1 AND SHIP:STATUS ="FLYING" AND LV_PCS = 1 AND LV_PCS_STAGE > 0 THEN {
	PrtLog("LIQ.FUEL IN PCS STAGE "+LV_PCS_STAGE+" EMPTY - STAGING").
	STAGE.
	SET LV_PCS_STAGE TO LV_PCS_STAGE -1.
	PrtLog("REMAINING PCS STAGES: "+LV_PCS_STAGE).
	PRESERVE.
}.


// STAGE WHEN OUT OF FUEL - DIFFERENT APPROACH THEN PCS
//WHEN SHIP:MAXTHRUST < 0.1 AND LIFT_STAGE > 0 THEN {
WHEN STAGE:LIQUIDFUEL < 0.2 AND (SHIP:STATUS ="FLYING" OR SHIP:STATUS="SUB_ORBITAL") AND LIFT_STAGE > 0 AND SRB_STAGE < 1 THEN {
	PrtLog("LIQ.FUEL END - STAGING").
	STAGE.
//	WAIT 0.5.
	WAIT 1.
	PrtLog("STARTING NEXT ENGINE").
	STAGE.
	SET LIFT_STAGE TO LIFT_STAGE -1.
	PrtLog("REMAINING LIFT STAGES: "+LIFT_STAGE).
	PRESERVE.
	}.

// START MAIN PROGRAM - (L)AUNCH (T)O (O)RBIT

//VELOCITY CONTROLL AND PITCHING
WHEN ALTITUDE > gt0 -1 THEN {
PrtLog("TURN OFF STABILITY ASSIST - CONTROLL TO kOS").
SAS OFF.
}.

until altitude > ha or apoapsis > DIRAP {
PrtMissParam().
    set ar to alt:radar.
    // control attitude
    if ar > gt0 and ar < gt1 {
  	set pitch to (90*(((cos(((ar - gt0)/(gt1 - gt0))*180)+1)/2)-1))+90. 		//FREAKY MATH THANKS INTERNET
//	set pitch to (90*(((cos(((ar - gt0)/(gt1 - gt0))*180)+0.75)/2)-1))+90. 		//FREAKY MATH THANKS INTERNET
	lock steering to HEADING(DIRHDG,pitch).
//   print tset at (20,11). 				// DEBUG STUFF
    print round(pitch) at (57,4).			// DEBUG STUFF
    }
    if ar > gt1 {
	lock steering to HEADING(DIRHDG,pitch).
    }
//(www) dynamic pressure q
    set ad to ad0 * euler^(-altitude/sh).    		//(www) atmospheric density
    set q to 0.5 * ad * (velocity:surface:mag)^2.
    print "Q:" at (49,3).				//PRINT NICE Q
    print round(q)+"  " at (56,3).			//PRINT MAX Q IN SCREEN


//(www) calculate target velocity
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
    // (www) thrust to compensate atmospheric drag losses
    until altitude > ha {
	PrtMissParam().
        // calculate target velocity
        if apoapsis >= DIRAP { set tset to 0. }
        if apoapsis < DIRAP { set tset to (DIRAP-apoapsis)/(DIRAP*0.01). }  //mostly from (www) changes made
        wait 0.1.
    }
}.
lock throttle to 0.
// CREATING MANEUVER NODE WITH "DIRAP" AS A TARGET APOAPSIS (APONODE)
PrtLog("APOAPSIS MANEUVER, ORBITING " + body:name).
PrtLog("APOAPSIS: " + round(apoapsis/1000) + "km").
Prtlog("PERIAPSIS: " + round(periapsis/1000) + "km -> " + round(DIRAP/1000) + "km").

// present orbit properties
set vom to velocity:orbit:mag. 					 // actual velocity
set r to rb + altitude.      					 // actual distance to body
set raa to rb + apoapsis.       				 // radius in apoapsis
set va to sqrt( vom^2 + 2*mu*(1/raa - 1/r) ). 			 // velocity in apoapsis
set a to (periapsis + 2*rb + apoapsis)/2. 			 // semi major axis present orbit
// future orbit properties
set r2 to rb + apoapsis.    					 // distance after burn at apoapsis
set a2 to (DIRAP + 2*rb + apoapsis)/2. 				 // semi major axis target orbit
set v2 to sqrt( vom^2 + (mu * (2/r2 - 2/r + 1/a - 1/a2 ) ) ).    // I HAVE NO IDEA
// setup node
set deltav to v2 - va.
PrtLog("APOAPSIS BURN: " + round(va) + ", DV:" + round(deltav) + " -> " + round(v2) + "m/s").
set nd to node(time:seconds + eta:apoapsis, 0, 0, deltav).
add nd.
PrtLog("NODE CREATED").
// END CREATING MANEUVER NODE (APONODE)

// EXECUTE MANEUVER NODE (EXENODE)
set nd to nextnode.
PrtLog("NODE APOAPSIS: " + round(nd:orbit:apoapsis/1000,2) + "km, PERIAPSIS: " + round(nd:orbit:periapsis/1000,2) + "km").
PrtLog("NODE IN: " + round(nd:eta) + ", DELTA-V: " + round(nd:deltav:mag)).
set maxa to maxthrust/mass.
set dob to nd:deltav:mag/maxa.     // incorrect: should use tsiolkovsky formula
PrtLog("MAX ACC: " + round(maxa) + "m/s^2, BURN DURATION: " + round(dob) + "s").
PrtLog("TURNING SHIP TO BURN DIRECTION").
sas off.
rcs off.
// workaround for steering:pitch not working with node assigned
set np to R(0,0,0) * nd:deltav.
lock steering to np.

until abs(np:direction:pitch - facing:pitch) < 0.1 and abs(np:direction:yaw - facing:yaw) < 0.1 {
PrtMissParam().
wait 0.1.
}.

//PRINT PARAMETERS UNTIL HALF BURNING TIME
UNTIL nd:eta <= (dob/2) {
PrtMissParam().
wait 0.1.
}.

PrtLog("ORBITAL BURN START " + round(nd:eta) + "s BEFORE APOAPSIS.").
set tset to 0.
lock throttle to tset.
// keep ship oriented to burn direction even with small dv where node:prograde wanders off
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
	PrtLog("THROTTLING DOWN, REMAIN DV " + round(nd:deltav:mag) + "m/s, FUEL:" + round(stage:liquidfuel)).
        set once to False.
    }
    if vdot(dv0, nd:deltav) < 0 {
       PrtLog("END BURN, REMAIN DV " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1)).
        lock throttle to 0.
        break.
    }
    if nd:deltav:mag < 0.1 {
        PrtLog("FINALIZING, REMAIN DV " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1)).
        wait until vdot(dv0, nd:deltav) < 0.5.
        lock throttle to 0.
        PrtLog("END BURN, REMAIN dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1)).
        set done to True.
    }
}
unlock steering.
PrtLog("APOAPSIS: " + round(apoapsis/1000,2) + "km, PERIAPSIS: " + round(periapsis/1000,2) + "km").
PrtLog("FUEL AFTER BURN: " + round(stage:liquidfuel)).
wait 1.
remove nd.
PrtLog("Extending Solarpanels").
PANELS ON.

PrtLog("PROGRAM FINISHED").
SET END_PROGRAM TO 1.

WAIT UNTIL END_PROGRAM =1.
IF addons:rt:hasconnection(SHIP) = True AND LOG2FILE = 1 {
	PrtLog("TRANSFERRING MISSION LOG TO GROUND CONTROLL").
	copylog().
	PrtLog("DELETING MISSION LOG FROM MEMORY").
	deletelog().
	PrtLog("STARTING NEW MISSION LOG").
	}
ELSE
	{
	PrtLog("NO CONNECTION TO GROUND CONTROL POSSIBLE - MISSION LOG WILL NOT BE COPIED AND DELETED").
	}.
PrtLog("DELETING LTO FROM MEMORY").
deletepath("1:/lto").
deletepath("1:/mission").

IF AFTERLTO = 1 {
	switch to 0.
	run otools.
}
