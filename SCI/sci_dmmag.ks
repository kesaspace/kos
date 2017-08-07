declare parameter modus.

run kesalib.

if modus = "init" {
set part_dmmag to SHIP:PARTSNAMED("dmmagboom")[0].
set mod_dmmag to part_dmmag:getmodule("DMModuleScienceAnimate").
}

else if modus = "log_mag" {
//mod_goo:doevent("observe mystery goo").
mod_dmmag:deploy.
}
else if modus = "transmit" {
	mod_dmmag:transmit().
}
else if modus = "reset" {
	mod_dmmag:reset().
}
else if modus = "help" { print "Parameters are: init|log_mag|transmit|reset".}.
else  { print "Parameters are: init|log_mag|transmit|reset".}.

