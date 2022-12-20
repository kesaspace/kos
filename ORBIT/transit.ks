// Simple Script to get into orbit of the target body
// Usage: 
// 1. make a insertion burn to the other body
// 2. set a node at the PE of the other body 
// 3. run transit($body) (example: run transit(Mun))
// 4. wait

declare parameter next_body.
SET TEXTLINE TO 2.
run kesalib.
run bodyprops.
run mission.

if not (defined NO_FIRST_RUN) {
  MissScrInit().
}.
//clearscreen.
MissScrInit().
PrtMissParam().
PrtLog("ACTUAL BODY: "+ body:name).
PrtLog("Next BODY set to " + next_body).
PrtLog("Ship In Transit.. waiting until reach " + next_body).


UNTIL SHIP:BODY = next_body {
PrtMissParam().
WAIT 1.
}.

PrtLog("ARRIVED AT "+ body:name).
SET NO_FIRST_RUN to 1.
//run perinode(O_BODY_AE).
run exenode.
