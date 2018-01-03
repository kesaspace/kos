run kesalib.
IF addons:rt:hasconnection(SHIP) = True {
        PrtLog("TRANSFERRING MISSION LOG TO GROUND CONTROLL").
        copylog().
        PrtLog("DELETING MISSION LOG FROM MEMORY").
        deletelog().    
        PrtLog("STARTINFG NEW MISSION LOG").
        }   
ELSE 
        {   
        PrtLog("NO CONNECTION TO GROUND CONTROLL POSSIBLE - MISSION LOG WILL NOT BE COPIED AND DELETED").
        }.  
