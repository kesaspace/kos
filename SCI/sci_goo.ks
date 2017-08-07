declare parameter modus.

run kesalib.

if modus = "init" {
set part_goo to SHIP:PARTSNAMED("GooExperiment")[0].
set mod_goo to part_goo:getmodule("ModuleScienceExperiment").
}

else if modus = "watch_goo" {
//mod_goo:doevent("observe mystery goo").
	mod_goo:deploy.
}
else if modus = "transmit" {
	mod_goo:transmit().
}
else if modus = "reset" {
	mod_goo:reset().
}
else if modus = "help" { print "Parameters are: init|watch_goo|transmit|reset".}.

