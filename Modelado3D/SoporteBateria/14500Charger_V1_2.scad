// LiIon 14500 battery charger
// DonJuanito - V1.2 - 2018-10-01

// --- Battery contacts ---
BATTERYCONTACTS = true; // If false, use nickel strips
BCWT = 0.8;     // Battery contacts retainers wall thickness
BCWO = 1.4;     // Battery contacts retainers wall overlap
BCPW = 10.2;    // Battery contacts positive width
BCPH = 9.2;     // Battery contacts positive height
BCPT = 0.6;     // Battery contacts positive thickness
BCPPW = 3.0;    // Battery contacts positive pad width
BCPST = 1.0;    // Battery contacts pad thickness
BCNW = 10.2;    // Battery contacts negative width
BCNH = 9.2;     // Battery contacts negative height
BCNT = 0.6;     // Battery contacts negative thickness
BCNPW = 3.0;    // Battery contacts negative pad width
BCNST = 3.0;    // Battery contacts negative (spring compressed) thickness

// --- Battery description ---
// 14500
CBLB = 50.0;    // Battery cavity length
CBD = 14.2;     // Battery diameter
// --- Texts ---
// Signs
CTH = 6.0;      // Signs texts height
CTD = 0.4;      // Signs texts depth
CTFYC = 0.0;    // Signs font based absolute Y offset correction
CTYO = 2.8;     // Signs Y offset of texts
CTF = "Arial:style=Black"; // Signs font
// Battery type text
CBTH = 5.0;     // Battery type texts height
CBTD = 0.4;     // Battery type texts depth
CBTF = "Arial:style=Black"; // Battery type font
CBTT = "LiIon 14500";   // Battery type text

/*
// 18650 *** ADJUST TO YOUR BATTERY TYPE IF NEEDED (protection PCB, contacts, ...) ***
CBLB = 65.0;    // Battery cavity length
CBD = 18.2;     // Battery diameter
// --- Texts ---
// Signs
CTH = 4.0;      // Signs texts height
CTD = 0.4;      // Signs texts depth
CTFYC = 0.0;    // Signs font based Y offset correction
CTYO = 1.8;     // Signs Y offset of texts
CTF = "Arial:style=Black"; // Signs font
// Battery type text
CBTH = 6.0;     // Battery type texts height
CBTD = 0.4;     // Battery type texts depth
CBTF = "Arial:style=Black"; // Battery type font
CBTT = "LiIon 18650";   // Battery type text
*/

// --- Box description ---
CBWW = 3.0;     // Battery vertical walls width (minimal width)
CSWW = 3.0;     // Batery to charger separator vertical wall width
CCWW = 1.0;     // Charger module front vertical wall width
CCTWH = 1.0;    // Charger module top retainers height
CCTWW = 0.6;    // Charger module top retainers width
CCTWL = 5.0;    // Charger module top retainers length
CCTWO = 2.0;    // Charger module top retainers offset
CCTSW = 0.4;    // Charger module top retainers slit cutout width
CCTBW = 1.6;    // Charger module retainers back wall width
CHWW = 2.0;     // Base wall thickness
CBZH = CBD * 0.85; // Battery walls height (should 'cover' the height of the battery contacts if needed)

// --- TP4056 charger module *** CHECK YOUR MODEL BEFORE PRINTING! *** ---
/*
// Newer TP4056 charger PCBs
CML = 22.8; // Charger module length
CMW = 17.2; // Charger module width
CMPH = 1.6; // Charger module PCB thickness
CMUW = 9.0; // USB connector cutout width
CMUH = 3.4; // USB connector cutout height
*/
// Older TP4056 charger PCBs (micro or mini USB), wider and longer
CML = 25.4; // Charger module length
CMW = 19.6; // Charger module width
CMPH = 1.4; // Charger module PCB thickness
CMUW = 10.0; // USB connector cutout width
CMUH = 3.4; // USB connector cutout height

// --- Wires ---
CWD = 1.4;  // Wires diameter
//CCTSH = CCTWH + CMPH; // Charger top retainers slit cutout height
CCTSH = 4.0; // Charger top retainers slit cutout height

// --------------------------------------------------------------
// Calculations
// --------------------------------------------------------------

$fn = 36*2; // Cylinders definition

// Effective battery cavity length calculation
CBL = BATTERYCONTACTS ? CBLB+ (BCPST-BCWT) + (BCNST-BCWT) : CBLB;
echo(CBL=CBL);

CEX = CCWW + CSWW + CBWW + CBL + CML;
CEY = 2*CBWW + max(CBD, CMW);
CEZ = CHWW + CBZH;
CMCD = (CEZ-CHWW-CMPH-CCTWH)*2;
CWXL = CWD+CSWW+CBL+CBWW;
CWZH = CEZ-CHWW-CMPH;
CCTBC = (CEY-CMW-2*CCTBW)/2;

// --------------------------------------------------------------
// Modules
// --------------------------------------------------------------

module Charger() {
    
    difference() {
        // +++
        // External volume
        translate([0, 0, 0])
            cube([CEX, CEY, CEZ], center=false);
        // ---
        // Charger module cutouts
        translate([CCWW, (CEY-CMW)/2, CHWW])
            cube([CML, CMW, CEZ], center=false); // Main
        translate([CCWW+CML-CMCD/2, -0.2/2, CHWW+CMPH+CCTWH+CMCD/2])
            rotate([-90, 0, 0])
            cylinder(d=CMCD, h=CEY+0.2, center=false); // Corner
        translate([-0.1-CMCD/2, -0.2/2, CHWW+CMPH+CCTWH])
            cube([CCWW+CML+0.1, CEY+0.2, CEZ], center=false); // Top
//        translate([-0.1, -0.2/2, CHWW+CMPH+CCTWH+CMCD/2])
//            cube([CCWW+CML+0.1, CEY+0.2, CEZ], center=false); // Bot
        translate([-0.2/2, (CEY-CMUW)/2, CHWW+CCTWH])
            cube([CCWW+0.2, CMUW, CMUH], center=false); // USB mouth
        translate([CCWW+CCTWO-CCTSW, -0.2, CBWW+CMPH-CCTSH]) // Retainers slits
            cube([CCTSW, (CEY-CMW)/2+CCTSW+0.2, CCTSH+0.2], center=false);
        translate([CCWW+CCTWO-CCTSW, CEY-(CEY-CMW)/2-CCTSW, CBWW+CMPH-CCTSH]) // Retainers lateral slits
            cube([CCTSW, (CEY-CMW)/2+CCTSW+0.2, CCTSH+0.2], center=false);
        translate([CCWW+CCTWO+CCTWL, -0.2, CBWW+CMPH-CCTSH]) // Retainers slits
            cube([CCTSW, (CEY-CMW)/2+CCTSW+0.2, CCTSH+0.2], center=false);
        translate([CCWW+CCTWO+CCTWL, CEY-(CEY-CMW)/2-CCTSW, CBWW+CMPH-CCTSH]) // Retainers lateral slits
            cube([CCTSW, (CEY-CMW)/2+CCTSW+0.2, CCTSH+0.2], center=false);

        translate([CCWW+CCTWO-0.2/2, (CEY-CMW)/2, CHWW+CMPH-CCTSH+CCTWH]) // Retainers longitudinal slits
            cube([CCTWL+0.2, CCTSW, CCTSH-CCTWH], center=false);
        translate([CCWW+CCTWO-0.2/2, (CEY+CMW)/2-CCTSW, CHWW+CMPH-CCTSH+CCTWH]) // Retainers longitudinal slits
            cube([CCTWL+0.2, CCTSW, CCTSH-CCTWH], center=false);
        translate([CCWW+CCTWO-0.2/2, -0.2, CBWW+CMPH+CCTWH-CCTSH]) // Retainers wall width
            cube([CCTWL+0.2, CCTBC+0.2, CCTSH+0.2], center=false);
        translate([CCWW+CCTWO-0.2/2, CEY-CCTBC, CBWW+CMPH+CCTWH-CCTSH]) // Retainers wall width
            cube([CCTWL+0.2, CCTBC+0.2, CCTSH+0.2], center=false);
        // Battery cavity cutout
        translate([CCWW+CML+CSWW, CEY/2, CHWW])
        hull() {
            translate([0, 0, CBD/2])
            rotate([0, 90, 0])
                cylinder(d=CBD, h=CBL, center=false);
            translate([0, -CBD/2, CBD/2])
                cube([CBL, CBD, CBD], center=false);
        }
        // Battery access cutout
        translate([CCWW+CML+CSWW+CBL/2, CEY/2, CEZ+CBD*0.1])
        resize([CBL*0.75, 0, CBD*1.2])
        rotate([90, 0, 0])
            cylinder(d=10.0, h=CBL*2, center=true);
        // Wires cutouts
        translate([CEX-CWXL, -0.2, CHWW+CMPH]) // - X side
            cube([CWXL+0.2, CWD+0.2, CWD], center=false);
        translate([CCWW+CML-CWD, -0.2, CHWW+CMPH]) // - Charger side
            cube([CWD, CEY/2+0.2, CWD], center=false);
        translate([CEX-CWD, -0.2, CHWW+CMPH]) // - Battery side (H)
            cube([CWD+0.2, (CEY+CWD)/2+0.2, CWD], center=false);
        translate([CEX-CWD, (CEY-CWD)/2, CHWW+CMPH]) // - Battery side (V)
            cube([CWD+0.2, CWD, CWZH+0.2], center=false);
        translate([CEX-CBWW-0.2/2, (CEY-CWD)/2, CEZ-CWD]) // - Battery side (V)
            cube([CBWW+0.2, CWD, CWD+0.2], center=false);
        // Texts
        #translate([CCWW+CML+CSWW+CTH/2, CTYO+CTFYC, CHWW+CBZH+0.001-CTD/2])
        linear_extrude(height=CTD, center=true, convexity=10)
        rotate([0, 0, 90])
            text("+", size=CTH, font=CTF, halign="center", valign="center");
        #translate([CCWW+CML+CSWW+CTH/2, CEY-CTYO+CTFYC, CHWW+CBZH+0.001-CTD/2])
        linear_extrude(height=CTD, center=true, convexity=10)
        rotate([0, 0, 90])
            text("+", size=CTH, font=CTF, halign="center", valign="center");
        #translate([CCWW+CML+CSWW+CBL-CTH/2, CTYO+CTFYC, CHWW+CBZH+0.001-CTD/2])
        linear_extrude(height=CTD, center=true, convexity=10)
        rotate([0, 0, 90])
            text("−", size=CTH, font=CTF, halign="center", valign="center");
        #translate([CCWW+CML+CSWW+CBL-CTH/2, CEY-CTYO+CTFYC, CHWW+CBZH+0.001-CTD/2])
        linear_extrude(height=CTD, center=true, convexity=10)
        rotate([0, 0, 90])
            text("−", size=CTH, font=CTF, halign="center", valign="center");
        translate([    CCWW+CML+CSWW+CBL/2,
                        CEY/2,
                        CHWW-CBTD+(CBTD+CBZH+CHWW)/2])
        linear_extrude(height=CBTD+CBZH+CHWW, center=true, convexity=10)
            text(CBTT, size=CBTH, font=CTF, halign="center", valign="center");
        // Battery clips
        if (BATTERYCONTACTS) {
//            // DEBUG: Show battery central axis
//            %translate([CCWW+CML+CSWW-CBL/2, CEY/2, CHWW])
//            translate([0, 0, CBD/2])
//            rotate([0, 90, 0])
//                cylinder(d=1.0, h=CBL*2, center=false);
            
            // Positive clip main volume
            translate([ CCWW+CML+CSWW-BCPT-BCWT,
                        (CEY-BCPW)/2,
                        CHWW+(CBD-BCPH-BCWT)/2]) {
                cube([BCPT, BCPW, BCPH+20], center=false); // Clip
                translate([BCPT-0.2/2, BCWO, BCWO])
                    cube([BCWT+0.2, BCPW-BCWO*2, BCPH-BCWO+20], center=false); // Clip overlap
                translate([-CSWW-0.2/2, (BCPW-BCPPW)/2, BCPH])
                    cube([CSWW+0.2, BCPPW, 20], center=false); // Pad cutout
            }
            // Negative clip main volume
            translate([ CCWW+CML+CSWW+BCWT+CBL,
                        (CEY-BCNW)/2,
                        CHWW+(CBD-BCNH-BCWT)/2]) {
                cube([BCNT, BCNW, BCNH+20], center=false); // Clip
                translate([-(BCWT+0.2/2), BCWO, BCWO])
                    cube([BCWT+0.2, BCNW-BCWO*2, BCNH-BCWO+20], center=false); // Clip overlap
                translate([BCWT/2-0.001, (BCNW-BCNPW)/2, BCNH])
                    cube([CBWW+0.2, BCNPW, 20], center=false); // Pad cutout
            }
        }
    }
    // Charger PCB retainers
    translate([CCWW+CCTWO, CBWW, CHWW+CMPH])
    hull() {
        cube([CCTWL, CCTWW, 0.001], center=false);
        translate([0, 0,CCTWH])
            cube([CCTWL, 0.001, 0.001], center=false);
    }
    translate([CCWW+CCTWO, CBWW+CMW-CCTWW, CHWW+CMPH])
    hull() {
        cube([CCTWL, CCTWW, 0.001], center=false);
        translate([0, CCTWW,CCTWH])
            cube([CCTWL, 0.001, 0.001], center=false);
    }
}

// --------------------------------------------------------------
// Render
// --------------------------------------------------------------

Charger();
