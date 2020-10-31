// KESA KOS LIBS
// writen by WeirdCulture - Master of KESA SPACE
// REMARKS:
// POS COL 3, ROW 3 FOR Q
// POS COL 3, ROW 4-5 FOR DEBUGGIMNG
global TTIME is 0.

declare function MissScrInit {
//SET TERMINAL:HEIGHT TO 50.
//SET TERMINAL:WIDTH TO 70.
CLEARSCREEN.
SET TEXTLINE TO 9.
PRINT "---------------------------------------------------------------------".
PRINT " DATE                  | FUEL SOLID            | NODE                ".
PRINT " TIME                  | FUEL LQ-SHIP          | COM                 ".
PRINT " MTIME                 | FUEL LQ-STAG          | Q                   ".
PRINT " ORBITING              | FUEL MPROP            | ANG                 ".
PRINT " STATUS                | E-CHARGE              |	                    ".
PRINT "---------------------------------------------------------------------".
PRINT "                                                                     ".
PRINT "---------------------------------------------------------------------".
PRINT SHIP:NAME+" MISSION LOG"  at (23,7).
}.

declare function LandScrInit {
print "ALT-ORB:" at (49,3).
print "ALT-RAD:" at (49,4).
print "V-SPD:" at (49,5).
}.

declare function PrtMissParam {
if addons:rt:hasconnection(SHIP) = True { set COMCON to "CONNECTED". } else { SET COMCON TO "NOT CONNECTED". }. //HAS THE SHIP CONNECTION
if hasnode= True { set MNODE to "SET". } else { SET MNODE to "NONE". }.   // IS NODE AVIABLE

//COL1
print "Y:"+TIME:YEAR AT (10,1).				//YEAR
print " D:"+TIME:DAY AT (14,1).				//DAY
print f_getTIME at (10,2).				//TIME
print round (MISSIONTIME,2) AT (10,3).			//MISSSION TIME
print BODY:NAME at (10,4).				//ORBITING BODY
print SHIP:STATUS+"   " at (10,5). 			//STATUS
//COL2
print round(STAGE:SOLIDFUEL,1) AT (38,1).    		//FUEL (STAGE) SOLID
print round(SHIP:LIQUIDFUEL,1) AT (38,2).		//FUEL (SHIP) LIQUID
print round(STAGE:LIQUIDFUEL,1) AT (38,3).		//FUEL (STAGE) LIQUID
print round(STAGE:MONOPROPELLANT,1) AT (38,4).		//FUEL (STAGE) NONOP
print round(STAGE:ELECTRICCHARGE,1) AT (38,5).		//FUEL (STAGE) ELECTRIC
//COL 3
print MNODE+"    " at (57,1).				//NODE AVIABLE?
print COMCON+"    " at (57,2). 				//CONNECTED ?
}.

declare function PrtLandParam {
print round(SHIP:ALTITUDE,1) at (57,3).			//SHIP ALTITUDE
print round(ALT:RADAR,1) at (57,4).			//SHIP ALTITUDE (RADAR)
print round(SHIP:VERTICALSPEED,2) at (57,5).		//SHIP VERTICAL SPEED
}.

declare function f_getCOM {
if addons:rt:hasconnection(SHIP) = True { set COMCON to "CONNECTED". } else { SET COMCON TO "NOT CONNECTED". }. //HAS THE SHIP CONNECTION
}.

//FUNCTION TO GET TIME(r.sec)
declare function f_getTIME {
set TTIME TO TIME:HOUR+":"+TIME:MINUTE+":"+round(TIME:SECOND).
return TTIME.
}.
//COPY LOG TO ARCH 0
declare function copylog {
copypath ("mission.log","0:log_"+SHIP:NAME+"_"+TIME:YEAR+"_"+TIME:DAY+"_"+TIME:HOUR+"_"+TIME:MINUTE+"_"+round(TIME:SECOND)+".log").
}.
//DELETE LOG FROM ACTIVE ARCHIVE
declare function deletelog {
deletepath ("mission.log").
}.
//PRINT LOG IN LOGFILE AND SCREEN
SET LOGFILE TO "mission.log".
declare function PrtLog {
declare parameter LOGTEXT.
PRINT "| "+f_getTIME+"("+round(MISSIONTIME,2)+"): "+LOGTEXT AT(0,TEXTLINE).
PRINT "|" AT (70,TEXTLINE).
IF LOG2FILE = 1 {
log "Y "+TIME:YEAR+" D "+TIME:DAY+" "+f_getTIME+"("+round(MISSIONTIME,2)+"): "+LOGTEXT TO LOGFILE.
}.
SET TEXTLINE TO TEXTLINE +1.
SET TERMINAL:WIDTH TO 70.
SET TERMINAL:HEIGHT TO 60.
IF TEXTLINE > 55 {
MissScrInit().
SET TEXTLINE TO 15.
}.
}.
