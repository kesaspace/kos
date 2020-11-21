clearscreen.
run kesalib.

//PARAMETERS

//FUNCTIONS AND PROCEDURES
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
//	MissScrInit().
        IF PRESTAGE = 1 {
        PrtLog("MAIN ENGINE START").
        STAGE.
        LOCK THROTTLE TO 0.1.
        PrtLog("MAINTHROTTLE SET TO 10%").
        WAIT 0.25.
				LOCK THROTTLE TO 0.25.
				PrtLog("MAINTHROTTLE SET TO 25%").
				WAIT 0.25.
				PrtLog("MAINTHROTTLE SET TO 50%").
        LOCK THROTTLE TO 0.5.
        WAIT 0.75.
				PrtLog("MAINTHROTTLE SET TO 75%").
        LOCK THROTTLE TO 0.5.
        WAIT 0.25.
        PrtLog("MAINTHROTTLE SET TO 100%").
        LOCK THROTTLE TO 1.
        WAIT 2.0.
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
SET TERMINAL:HEIGHT TO 60.
SET TERMINAL:WIDTH TO 80.
SET TERMINAL:BRIGHTNESS TO 1.0.
MissScrInit().
PrtMissParam().
IF SIMRUN = 0 {
 waitstart(STARTYEAR,STARTDAY,STARTHOUR,STARTMIN,STARTSEC).
}.
countdown (CNTDWN,PRELAUNCH_STG).
