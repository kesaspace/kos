// Deploy Antenna
// written for KomSat Min 


set ant to SHIP:PARTSNAMED("mediumDishAntenna")[0].
set m_ant to ant:GETMODULE("ModuleRTAntenna").
m_ant:doevent("activate").
m_ant:setfield("target", "active-vessel").


set ant to SHIP:PARTSNAMED("mediumDishAntenna")[1].
set m_ant to ant:GETMODULE("ModuleRTAntenna").
m_ant:doevent("activate").
m_ant:setfield("target", minmus).
