declare parameter modus.

run kesalib.

if modus = "init" {
	set part_therm to SHIP:PARTSNAMED("sensorThermometer")[0].
	set mod_therm to part_therm:getmodule("ModuleScienceExperiment").
}
else if modus = "log_temp" {
//	mod_therm:doevent("log temperature").
	mod_therm:deploy.
}
else if modus = "transmit" {
	mod_therm:transmit().
}
else if modus = "reset" {
	mod_therm:reset().
}
else if modus = "help" {
print "Parameters are: init|log_temp|transmit|reset".}.
else { print "Parameters are: init|log_temp|transmit|reset".}.

