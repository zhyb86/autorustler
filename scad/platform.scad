DRAW_RPI = 1;

// all coordinates are in hundredths of an inch
module batteryholder() {
  difference() {
    union() {
      linear_extrude(height = 7) {
        difference() {
          union () {
            translate([-111.5, 0, 0]) circle(r = 20.5, $fn = 100);
            translate([111.5, 0, 0]) circle(r = 20.5, $fn = 100);
            square([223, 41], center = true);
          }
          translate([-111.5, 0, 0]) circle(r = 12, $fn=40);
          translate([111.5, 0, 0]) circle(r = 12, $fn=40);
        }
      }
      translate([0,0,10.4]) cube([189, 41, 7.2], center = true);
    }
    translate([0, 0, 10.4]) cube([52, 27, 7.4], center = true);
    translate([-60, 0, 10.4]) cube([52, 27, 7.4], center = true);
    translate([60, 0, 10.4]) cube([52, 27, 7.4], center = true);
  }
}

// add two bosses facing up w/ raspberry pi at center
// for sd card clearance height must be at least .15"

// the entire enclosure must be at least 4.75" wide (x direction) to fit the SD
// card and usb ports
module rpi_bosses(height = 18) {
  mm_l = 85;  // in mm
  mm_w = 56;

  module boss(pos) {
    translate(pos) {
      difference() {
        cylinder(h=height, d=6 / 0.254);
        translate([0, 0, 2] / 0.254) cylinder(h=height, d=2 / 0.254);
      }
    }
  }

  hole1 = [-mm_l/2 + 5, -mm_w/2 + 12.5, 0] / 0.254;
  boss(hole1);
  hole2 = [mm_l/2 - 25.5, mm_w/2 - 18, 0] / 0.254;
  boss(hole2);

  if (DRAW_RPI) {
    // rpi circuit board:
    translate([0, 0, 1.54+height]) {
      // circuit board itself
      color([0, 0.4, 0, 0.5])
        cube([mm_l, mm_w, 1.524] / 0.254, center = true);
      // sd card protrusion
      translate([mm_l/2 + 2, -4, -2] / 0.254)
        color([0, 0, 0, 0.5])
          cube([32, 24, 2.1] / 0.254, center = true);
    }
  }
}

module platform1() {
  h = 10;
  translate([0, -20 - 375/2, 75+h/2]) cube([500, 375, h], center=true);
}

module platform2() {
  h = 10;
  translate([0, 20 + 50 + 300/2, 20+h/2]) cube([475, 250, h], center=true);
  // raspberry pi mounting screw bosses
  // camera holder enclosure
}

// render with mm scale coordinates
scale([.254, .254, .254]) {
  rotate([180, 0, 0]) batteryholder();
  platform1();
  platform2();

  translate([-20, 20 + 50 + 300/2, 29])
    rpi_bosses();
}
