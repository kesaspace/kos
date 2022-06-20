# KESA kos repositoy

This is the KESA kOS repository. All stuff will be found here!

Documentation so far, mostly for me, I forgot a lot of stuff..

**set your *harddrive* to 20k**

Structure of the Scripts:

## Main Launch script LTO/launch (LaunchToOrbit)

Each script has some configuration scripts, and some running scripts

| Script Name | Type | Purpose | Used By |

### boot files

Each spacecraft has its on *bootfile* found in *boot*

SET SRB_STAGE TO 1.         // SRB STAGES
SET LIFT_STAGE TO 2.        // LIFTING STAGE
SET PRELAUNCH_STG TO 1.     // PRE LAUNCH STAGE
SET LV_FAIRING TO 1.        // FAIRING EXISTANT
SET LV_ANTENNA TO 1.        // ANTENNA SWITCH
SET LV_ESCAPE TO 0.         // ESCAPE SYSTEM
SET LV_PCS TO 0.            // PROPELLANT CROSSFEED SYSTEM
SET LV_PCS_STAGE TO 0.      // PROPELLANT CROSSFEED SYSTEM STAGES

| Parameter | Description |
|: --------| :--------- |
| SRB_STAGE | Stages with Solid Rocket Boosters |
| LIFT_STAGES| How many stages until end of Launch Script |
| PRELAUNCH_STG |How many stages until vehicle will liftoff |
| LV_FAIRING |Any Fairing |
| LV_ANTENNA |Is there any antenna on the vechicle and needed to be switched? |
| LV_ESCAPE |Any Escape System onboard |
| LV_PCS | Is any Propellant Crossfreed System (Asparagus) existant |
| LV_PCS_STAGE | How many of the PCS-stages are installed |

We have different scripts for different parts of the mission.
We have the main Library with supporting stuff:

- LIB/kesalib.ks

then there are some variables about planetary bodies

- LIB/bodyprops.ks

all you need to get into orbit is stored in the LTO (Launch To Orbit) folder.

The main scripts:
LTO/lto.ks
LTO/lctl.ks

## How to get into orbit?

1. Start at archive (if not "switch to 0." see kOS settings to start on archive)
2. "run launch.ks"

This will do following:

0. switch to aechive if not already done
1. Copy some files to the LV
   1. lto = the "Launch To Orbit" script.. the main script for getting of Kerbin
   2. lctl = the launch control script, stuff like pre launch handling and other things
   3. mission = mission for some basic stuff like start hdg and other stuff
   4. kesalib = main libary with functions needed for kesa (outpouts formating and other stuff )
   5. bodyprops = some definitions of space bodies
2. switch back to LV
3. run lto
   1. lto will read kesalib
   2. lto will read misssion
   3. lto will run lctl
   4. lto will get you into orbit

## What to do in orbit?

0. run otools if not done by lto by setting AFTERLTO to 1 in mission.ks
1. to change hight at periapsis do "run perinode($target-height)" e.g.  "run perinode(150000)" to set the node at PE to 150000.
2. to change hight at apoapsis do "run aponode($target-height)" e.g.  "run apoode(150000)" to set the node at AE to 150000.
3. to execute the next set node run "exenode"

## DISCLAIMER

I am using a lot of code from <http://kos.wikia.com/wiki/Mission_toolkit_v3> which is written b y "Baloan". I could not find any license there :(  Whoever you are, you have done a great job, even if I don't understand some parts why you did this and that in the way you did it. Her/his code is being used in following scripts:

- LTO/lto.ks
- LTO/bodyprops.ks
- ORBIT/*all of them* (exept copycode.ks)

All other lines of code are free to use, free to modify and free to distribute. All lines of code which are not made by "Baloan" are distributed under the "Beerware" license. (see LICENSE)

You can ask me anything about the scripts, maybe I will anwser you, maybe not, but I will not deepen into a discussion, with the most of you, why I am dooing things in this way and why not doing it in another way. I do not have the time for such things. Some parts of the scripts are being adapted to new technology which were invented by our Kerbal scientist.  


Prost, have fun and happy launchings
WeirdCulture
