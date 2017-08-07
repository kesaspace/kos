run kesalib.
// execute maneuver node
MissScrInit().
set nd to nextnode.
PrtLog("Node apoapsis: " + round(nd:orbit:apoapsis/1000,2) + "km, periapsis: " + round(nd:orbit:periapsis/1000,2) + "km").
PrtLog("Node in: " + round(nd:eta) + ", DeltaV: " + round(nd:deltav:mag)).
set maxa to maxthrust/mass.
set dob to nd:deltav:mag/maxa.     // incorrect: should use tsiolkovsky formula
PrtLog(" Max acc: " + round(maxa) + "m/s^2, Burn duration: " + round(dob) + "s").
PrtLog("Turning ship to burn direction.").
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

PrtLog("Orbital burn start " + round(nd:eta) + "s before apoapsis.").
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
PrtLog("Apoapsis: " + round(apoapsis/1000,2) + "km, periapsis: " + round(periapsis/1000,2) + "km").
PrtLog("Fuel after burn: " + round(stage:liquidfuel)).
wait 1.
remove nd.
set NODE_FINISHED TO 1.

