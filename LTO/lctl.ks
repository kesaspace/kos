clearscreen.
//run params.
run kesalib.

//PARAMETERS

//FUNCTIONS AND PROCEDURES
declare function waitstart {
declare parameter STARTYEAR.
declare parameter STARTDAY.
declare parameter STARTHOUR.
declare parameter STARTMIN.
declare parameter STARTSEC.
PrtLog("LAUNCH SCHEDULED TO: Y:"+STARTYEAR+" D:"+STARTDAY+" - "+STARTHOUR+":"+STARTMIN+":"+STARTSEC).
PrtLog("Waiting...").
UNTIL TIME:YEAR = STARTYEAR {
	PrtMissParam().
}.
PrtLog("DATE OF LAUNCH (YEAR) REACHED: "+STARTYEAR).
UNTIL TIME:DAY = STARTDAY {
	PrtMissParam().
}.
PrtLog("DATE OF LAUNCH (DAY) REACHED: "+STARTDAY).
IF WARP > 5 {
	SET WARP TO 5. 
}.
UNTIL TIME:HOUR = STARTHOUR {
	PrtMissParam().
}.
PrtLog("DATE OF LAUNCH (HOUR) REACHED: "+STARTHOUR).
IF WARP > 4 {
	SET WARP TO 4.
}.
UNTIL TIME:MINUTE = STARTMIN -10 {
	PrtMissParam().
}.
IF WARP > 3 {
SET WARP TO 3.
}.
UNTIL TIME:MINUTE = STARTMIN -1 {
	PrtMissParam().
}.
IF WARP > 2 {
SET WARP TO 2.
}.
UNTIL TIME:MINUTE = STARTMIN {
	PrtMissParam().
}.
PrtLog("DATE OF LAUNCH (MINUTE) REACHED: "+STARTMIN).
SET WARP TO 0.
UNTIL round(TIME:SECOND,0) = STARTSEC {
	PrtMissParam().
}.
PrtLog("DATE OF LAUNCH (SECOND) REACHED: "+STARTSEC).
}.



//countdown procedure
declare function countdown {
declare parameter CNTDWN.
declare parameter PRESTAGE.
        LOCK THROTTLE TO 0.
        UNTIL CNTDWN = 0 {
        PrtLog("Countdown T-" +CNTDWN).
        PrtMissParam().
                WAIT 1.
                SET CNTDWN to CNTDWN -1.
        }.
	MissScrInit().
        IF PRESTAGE = 1 {
        PrtLog("MAIN ENGINE START").
        STAGE.
        LOCK THROTTLE TO 0.1.
        PrtLog("MAINTHROTTLE SET TO 10%").
        WAIT 0.5.
        PrtLog("MAINTHROTTLE SET TO 50%").
        LOCK THROTTLE TO 0.5.
        WAIT 1.5.
        PrtLog("MAINTHROTTLE SET TO 100%").
        LOCK THROTTLE TO 1.
        WAIT 2.5.
        STAGE.
        PrtLog("LIFTOFF").
	SET LCTL_END TO 1.
        }
        ELSE {
        PrtLog("MAINTRHOTTLE SET TO 100%").
        PrtLog("LIFTOFF").
        LOCK THROTTLE TO 1.
        STAGE.
	SET LCTL_END TO 1.
        }.
}.

//BEGIN PRELAUNCH MAIN PROGRAM

MissScrInit().
PrtMissParam().
IF SIMRUN = 0 {
 waitstart(STARTYEAR,STARTDAY,STARTHOUR,STARTMIN,STARTSEC).
}.
countdown (CNTDWN,PRELAUNCH_STG).
