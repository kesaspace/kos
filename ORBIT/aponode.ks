declare parameter nodealt.
SET TEXTLINE TO 2.
run kesalib.
run bodyprops.
clearscreen.
// create apoapsis maneuver node
PrtLog("Apoapsis maneuver, orbiting " + body:name).
PrtLog("Apoapsis: " + round(apoapsis/1000) + "km").
//Prtlog("Periapsis: " + round(periapsis/1000) + "km -> " + round(alt/1000) + "km").

// present orbit properties
set vom to velocity:orbit:mag.  // actual velocity
set r to rb + altitude.         // actual distance to body
set raa to rb + apoapsis.        // radius in apoapsis
set va to sqrt( vom^2 + 2*mu*(1/raa - 1/r) ). // velocity in apoapsis
set a to (periapsis + 2*rb + apoapsis)/2. // semi major axis present orbit
// future orbit properties
set r2 to rb + apoapsis.    // distance after burn at apoapsis
set a2 to (nodealt + 2*rb + apoapsis)/2. // semi major axis target orbit
set v2 to sqrt( vom^2 + (mu * (2/r2 - 2/r + 1/a - 1/a2 ) ) ).
// setup node 
set deltav to v2 - va.
PrtLog("Apoapsis burn: " + round(va) + ", dv:" + round(deltav) + " -> " + round(v2) + "m/s").
set nd to node(time:seconds + eta:apoapsis, 0, 0, deltav).
add nd.
PrtLog("Node created.").
