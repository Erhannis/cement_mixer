/**
Run get_deps.sh to clone dependencies into a linked folder in your home directory.

Note, I think the wheels would work better if the Legs were rotated around
the z-axis some, but I'm not sure.  The problem is that the weight of the barrel
wants to push the wheels into an orientation that doesn't match the way the barrel
rotates.
*/

use <deps.link/BOSL/nema_steppers.scad>
use <deps.link/BOSL/joiners.scad>
use <deps.link/BOSL/shapes.scad>
use <deps.link/erhannisScad/misc.scad>
use <deps.link/erhannisScad/auto_lid.scad>
use <deps.link/scadFluidics/common.scad>
use <deps.link/quickfitPlate/blank_plate.scad>
use <deps.link/getriebe/Getriebe.scad>
use <deps.link/gearbox/gearbox.scad>

$FOREVER = 1000;
DUMMY = false;
$fn = DUMMY ? 10 : 60;

IN = 25.4;

// Casters 2.5*3.5, 6.5H
CASTER_SX = 2.5*IN;
CASTER_SY = 3.5*IN;
CASTER_SZ = 6.5*IN;

//BEAM_SX = 1.5*IN;
BEAM_SX = 3.5*IN;
BEAM_SZ = 3.5*IN;
PLATE_SZ = 16.16;
HALF_BEAM_SX = 3.5*IN;
HALF_BEAM_SZ = 1.5*IN;

ANGLE = 30;
CONTACT_A = 45;

BARREL_D = 14*IN;
BARREL_H = 27.5*IN;

ANNOYING_OFFSET = BEAM_SZ-sqrt(0.5*sqr(CASTER_SY));

module Caster() {
  tx(-CASTER_SX/2) cube([CASTER_SX, CASTER_SY, 10]);
  // Not quite right but close enough
  ty(CASTER_SY-0.5*IN) tz(0.5*IN+CASTER_SZ/2) ry(90) cylinder(d=CASTER_SZ-1*IN,h=CASTER_SX/2,center=true);
}

module Beam(l) {
  tx(-BEAM_SX/2) cube([BEAM_SX, l, BEAM_SZ]);
}

module HalfBeam(l) {
  tx(-HALF_BEAM_SX/2) cube([HALF_BEAM_SX, l, HALF_BEAM_SZ]);
}

module Leg(l) {
  rx(-90) tz(-BEAM_SZ/2) ty(-l-0.5*BEAM_SZ) {
    difference() {
      Beam(l+0.5*BEAM_SZ);
      rx(45) OZp();
    }
    translate([0,ANNOYING_OFFSET,ANNOYING_OFFSET]) rx(45) Caster();
  }
}

//color("green") region([[0.5*BEAM_SX-5*IN-ANNOYING_OFFSET,3*IN-0.5*BEAM_SX],[0,5]*IN,[-5,5]*IN]);
//echo("mid gap", ((0.5*BEAM_SX-5*IN-ANNOYING_OFFSET)-(3*IN-0.5*BEAM_SX))/-IN);

echo("4x4 beam, diag center cut = 1*",2*(3*IN)/IN);
echo("4x4 beam, diag center cut = 1*",2*(11*IN)/IN);
cmirror([0,1,0]) {
  ty(-ANNOYING_OFFSET) translate([3,-8,0]*IN) Leg(3*IN);
  ty(-ANNOYING_OFFSET) translate([16,-8,0]*IN) Leg(11*IN);
}
echo("4x4 beam, diag center cut, only one half = 1*",2*(4*IN+HALF_BEAM_SZ)/IN);
tz(-HALF_BEAM_SZ) tx(-5*IN-ANNOYING_OFFSET) rz(-90) Leg(4*IN+HALF_BEAM_SZ);
echo("2x4 crossbeams = 3*",(16*IN+HALF_BEAM_SX+2*ANNOYING_OFFSET)/IN);
tx(3*IN) ty(-16*IN/2-0.5*HALF_BEAM_SX-ANNOYING_OFFSET) mz() color("blue") HalfBeam(16*IN+HALF_BEAM_SX+2*ANNOYING_OFFSET);
tx(16*IN) ty(-16*IN/2-0.5*HALF_BEAM_SX-ANNOYING_OFFSET) mz() color("blue") HalfBeam(16*IN+HALF_BEAM_SX+2*ANNOYING_OFFSET);
tz(5*IN) tx(16*IN) ty(-16*IN/2-0.5*HALF_BEAM_SX-ANNOYING_OFFSET) tx(BEAM_SX/2) ry(90) tx(-HALF_BEAM_SX/2) color("blue") HalfBeam(16*IN+HALF_BEAM_SX+2*ANNOYING_OFFSET);
echo("2x4 parallelbeams = 3*",(21*IN+HALF_BEAM_SX+ANNOYING_OFFSET)/IN);
cmirror([0,1,0]) ctranslate([0,8*IN+ANNOYING_OFFSET,0]) tx(-5*IN-0.5*BEAM_SZ-ANNOYING_OFFSET) rz(-90) tz(-HALF_BEAM_SZ) mz() color("red") HalfBeam(21*IN+HALF_BEAM_SX+ANNOYING_OFFSET);

tz(-ANNOYING_OFFSET) translate([1,0,7]*IN) ry(90-ANGLE) tx(-BARREL_D/2) cylinder(d=BARREL_D,h=BARREL_H);
