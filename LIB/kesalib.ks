// KESA KOS LIBS
// version 0.1
// writen by WeirdCulture - Master of KESA SPACE

global TTIME is 0.

declare function MissScrInit {
SET TERMINAL:HEIGHT TO 50.
SET TERMINAL:WIDTH TO 70.
CLEARSCREEN.
SET TEXTLINE TO 9.
PRINT "---------------------------------------------------------------------".
PRINT " DATE                  | FUEL SOLID            | NODE                ".
PRINT " TIME                  | FUEL LIQUID           | COM                 ".
PRINT " MTIME                 | FUEL MPROP            | Q                   ".
PRINT " ORBITING              | E- CHARGE             |	                    ".
PRINT " STATUS                |                       |	                    ".
PRINT "---------------------------------------------------------------------".
PRINT "                                                                     ".
PRINT "---------------------------------------------------------------------".
PRINT SHIP:NAME+" MISSION LOG"  at (23,7).
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
print SHIP:STATUS+"      " at (10,5). //STATUS
//COL2 
print round(STAGE:SOLIDFUEL,1) AT (38,1).    		//FUEL (STAGE) SOLID
print round(SHIP:LIQUIDFUEL,1) AT (38,2).		//FUEL (STAGE) LIQUID
print STAGE:MONOPROPELLANT AT (38,3).			//FUEL (STAGE) NONOP
print round(STAGE:ELECTRICCHARGE,1) AT (38,4).		//FUEL (STAGE) ELECTRIC
//COL 3
print MNODE+"    " at (56,1).	//NODE AVIABLE?
print COMCON+"    " at (56,2). //CONNECTED ?
print round(STAGE:LIQUIDFUEL,1) AT (56,4).
}.

declare function f_getCOM {
if addons:rt:hasconnection(SHIP) = True { set COMCON to "CONNECTED". } else { SET COMCON TO "NOT CONNECTED". }. //HAS THE SHIP CONNECTION
}.

declare function f_getTIME {
set TTIME TO TIME:HOUR+":"+TIME:MINUTE+":"+round(TIME:SECOND).
return TTIME.
}.

declare function PrtLog {
declare parameter LOGTEXT.
PRINT "| "+f_getTIME+"("+round(MISSIONTIME,2)+"): "+LOGTEXT AT(0,TEXTLINE).
PRINT "|" AT (70,TEXTLINE).
SET TEXTLINE TO TEXTLINE +1.
IF TEXTLINE > 49 {
MissScrInit().
SET TEXTLINE TO 15.
}.
}.

