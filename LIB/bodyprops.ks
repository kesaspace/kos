// set celestial body properties
// ease future parametrisation
// adapted by WeirdCulture (KESA)
run kesalib.
set b to body:name.
set mu to 0.
if b = "Kerbin" {
    set mu to 3.5316000*10^12.  // gravitational parameter, mu = G mass
    set rb to 600000.           // radius of body [m]
    set soi to 84159286.        // sphere of influence [m]
    set ad0 to 1.2230948554874. // atmospheric density at msl [kg/m^3]
    set sh to 1000.             // scale height (atmosphere) [m]
    set ha to 69077.            // atmospheric height [m]
//    set lorb to 80000.          // low orbit altitude [m]
}
if b = "Mun" {
    set mu to 6.5138398*10^10.
    set rb to 200000.
    set soi to 2429559.
    set ad0 to 0.
    set lorb to 14000. 
}
if b = "Minmus" {
    set mu to 1.7658000*10^9.
    set rb to 60000.
    set soi to 2247428.
    set ad0 to 0.
    set lorb to 10000. 
}
if mu = 0 {
    PrtLog(" WARNING: no body properties for " + b + "!").
}
if mu > 0 {
    Prtlog(" Loaded body properties for " + b).
}
//set euler to 2.718281828.
//set pi to 3.1415926535.
// fix NaN and Infinity push on stack errors, https://github.com/KSP-KOS/KOS/issues/152
set config:safe to False.
