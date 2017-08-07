run kesalib.
set scind to nextnode.
set init to "init".
MissScrInit().

if round(scind:deltav:mag) > 0 {
PrtLog("!!! THIS IS A MANEUVERNODE! !!! ABOOOORT!").
}
else {
run sci_therm(init).
run sci_goo(init).
run sci_dmmag(init).
PrtLog("Experiments initialized").

until scind:eta < 10 {
PrtMissParam().
print "NODE IN " +round(scind:eta)+"  " at (49,3).
} 

run sci_therm("log_temp").
run sci_goo("watch_goo").
run sci_dmmag("log_mag").
PrtLog("Data gathered").
}.



