declare parameter alt.
SET TEXTLINE TO 2.
run mission.
run kesalib.
run bodyprops.


if not (defined NO_FIRST_RUN) {
  clearscreen.
}.

MissScrInit().

// create periapsis maneuver node
PrtLog("PERIAPSIS MENEUVER, ORBITING " + body:name).
PrtLog("APOAPSIS: " + round(apoapsis/1000) + "km -> " + round(alt/1000) + "km").
PrtLog("PERIAPSIS: " + round(periapsis/1000) + "km").
// constants: mu, rb
// present orbit properties
set vom to velocity:orbit:mag.  // actual velocity
set r to rb + altitude.         // actual distance to body
set ra to rb + periapsis.        // radius in periapsis
set va to sqrt( vom^2 + 2*mu*(1/ra - 1/r) ). // velocity in periapsis
set a to (periapsis + 2*rb + apoapsis)/2. // semi major axis present orbit
// future orbit properties
set r2 to rb + periapsis.              // distance after burn at periapsis
set a2 to (alt + 2*rb + periapsis)/2. // semi major axis target orbit
set v2 to sqrt( vom^2 + (mu * (2/r2 - 2/r + 1/a - 1/a2 ) ) ).
// setup node
set deltav to v2 - va.
PrtLog("PERIAPSIS BURN: " + round(va) + ", dv:" + round(deltav) + " -> " + round(v2) + "m/s").
set nd to node(time:seconds + eta:periapsis, 0, 0, deltav).
add nd.
PrtLog("NODE CREATED").
