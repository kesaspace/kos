run kesalib.
// execute maneuver node
MissScrInit().
set nd to nextnode.
PrtLog("NODE APOAPSIS: " + round(nd:orbit:APOAPSIS/1000,2) + "km, PERIAPSIS: " + round(nd:orbit:PERIAPSIS/1000,2) + "km").
PrtLog("NODE IN: " + round(nd:eta) + ", DELTA-V: " + round(nd:deltav:mag)).
set maxa to maxthrust/mass.
set dob to nd:deltav:mag/maxa.     // incorrect: should use tsiolkovsky formula
PrtLog(" MAX ACC: " + round(maxa) + "m/s^2, BURN DURATION: " + round(dob) + "s").
PrtLog("TURNING SHIP TO BURN DIRECTION.").
sas off.
rcs off.
// workaround for steering:pitch not working with node assigned
set np to R(0,0,0) * nd:deltav.
lock steering to np.
//PrtLog("WAIT DEBUG 1").

UNTIL nd:eta <= (dob/2) {
PrtMissParam().
wait 0.1.
}.

// STAGE WHEN OUT OF FUEL - DIFFERENT APPROACH THEN PCS
WHEN SHIP:MAXTHRUST < 0.1 THEN {
        PrtLog("LIQ.FUEL END - STAGING").
        STAGE.
        PrtLog("STARTING NEXT ENGINE").
        WAIT 1.
        STAGE.
        PRESERVE.
        }.  



PrtLog("ORBITAL BURN START " + round(nd:eta) + "s BEFORE APOAPSIS.").
set tset to 0.
lock throttle to tset.
// keep ship oriented to BURN direction even with small dv where node:prograde wanders off 
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
	PrtLog("THROTTLING DOWN, REMAIN dv " + round(nd:deltav:mag) + "m/s, FUEL:" + round(stage:liquidfuel)).
        set once to False.
    }
    if vdot(dv0, nd:deltav) < 0 {
       PrtLog("END BURN, REMAIN dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1)).
        lock throttle to 0.
        break.
    }
    if nd:deltav:mag < 0.1 {
        PrtLog("Finalizing, REMAIN dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1)).
        wait until vdot(dv0, nd:deltav) < 0.5.
        lock throttle to 0.
        PrtLog("END BURN, REMAIN dv " + round(nd:deltav:mag,1) + "m/s, vdot: " + round(vdot(dv0, nd:deltav),1)).
        set done to True.
    }
}
unlock steering.
PrtLog("APOAPSIS: " + round(APOAPSIS/1000,2) + "km, PERIAPSIS: " + round(PERIAPSIS/1000,2) + "km").
PrtLog("FUEL FUEL BURN: " + round(stage:liquidfuel)).
wait 1.
remove nd.
set NODE_FINISHED TO 1.
clearscreen.

