// Engine Naclles for Warthog Model

// Copyright (C) 2015 Peter Bennett <thelargeostrich@gmail.com>

// Contributor: Peter Bennett <thelargeostrich@gmail.com>
// Contributor: Jeremy Bennett <jeremy@jeremybennett.com>

// This file is licensed under the Creative Commons Attribution-ShareAlike 3.0
// Unported License. To view a copy of this license, visit
// http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to Creative
// Commons, PO Box 1866, Mountain View, CA 94042, USA.

// 45678901234567890123456789012345678901234567890123456789012345678901234567890

include <MCAD/boxes.scad>
include <MCAD/materials.scad>
include <MCAD/regular_shapes.scad>


// Small amount to ensure overlap of components
EPS = 0.001;

// Amount nacelle is rotated up or down
ROT = 5;


// The nacelle body
module nacelle_body () {
    hull () {
	translate (v = [0, 0,  0])
	    cylinder (h = 150, r = 30, $fn = 180);
	translate (v = [0, 0, 70])
	    cylinder(h = 60, r = 33, $fn = 180);
    }
}


// Cross bar we will be connecting to (to make a suitable surface)
module crossbar () {
    intersection () {
	rotate (a = [ROT, 0, 0])
	    hull () {
	        translate (v = [-50, 1, 72])
	            rotate (a = [0, 90, 0])
	                cylinder (h = 50, r = 6);
	        translate (v = [-50, 1, 80])
	            rotate (a = [0, 90,0])
	                cylinder(h = 50, r = EPS);
  	        translate (v = [-50, -5, 20])
	            rotate (a = [0, 90, 0])
	                cylinder (h = 50, r = EPS);
	        translate (v = [-50, 5, 20])
	            rotate (a = [0, 90, 0])
	                cylinder (h = 50, r = EPS);
	    }

	// Cube to provide a flat edge - x should be the diameter of the
	// nacelle body at its widest.
	cube (size = [66, 300, 500], center = true);
    }
}


// The nacelle duct
module nacelle_duct () {
    translate (v = [0, 0, -5])
        cylinder(h = 160, r = 27.5, $fn = 180);
}


// A duct for the wire
module wire_duct () {
    rotate (a = [ROT, 0, 0])
        translate (v = [-70, 1, 72]) {
	    rotate (a = [0, 90, 0])
                cylinder (h = 70, r = 4);
    }
}


// A basic M3 bolt hole.  Hex head retainer
module bolt_hole () {
    union () {
	// Head
	rotate (a = [0, -90, 0])
	    cylinder (h = 3, r = 5.5 / 2, $fn = 6);
	// Shank
	rotate (a = [0, -90, 0])
	    cylinder (h = 20, r = 3 / 2, $fn = 24);
    }
}

// Upper bolt_hole () {
module bolt_hole_upper () {
    rotate (a = [ROT, 0, 0])
	// Y offset is hull inner diameter, less a little bit
        translate (v = [-26.5, 0, 60])
            bolt_hole ();
}


// Upper bolt_hole () {
module bolt_hole_lower () {
    rotate (a = [ROT, 0, 0])
        translate (v = [-26.5, 0, 30])
            bolt_hole ();
}


// Outer lug within the nacelle, to hold it together
module lug () {
    intersection () {
	 // Boundary cylinder is inner radius of nacelle
	 cylinder (r = 27.5, h = 100, center = true, $fn = 180);
	 translate (v = [27.5 - 4, 0, 0])
	     difference () {
		 // Lug
		 union () {
		     cylinder (r = 4, h = 6, $fn = 24);
		     translate (v = [0, -4,0])
	                 cube (size = [4, 8, 6]);
		 }
		 // Screw head
		 translate (v = [0, 0, 4.5])
		     cylinder (r = 5.5 / 2, h = 2, $fn = 6);
		 // Screw shank
		 cylinder (r = 3 / 2, h = 20, center = true, $fn = 24);
	     }
    }
}


// Nacelle is body + crossbar, minus the duct, minus wire duct, minus bolt
// holes.  Then add in the outer lug
module nacelle () {
    difference () {
	union () {
	    nacelle_body ();
	    crossbar ();
	}
	nacelle_duct ();
	wire_duct ();
	bolt_hole_upper ();
	bolt_hole_lower ();
    }
    translate (v = [EPS, 0, 45 - 3])
        lug ();
}


NACELLE_UPPER = false;

if (NACELLE_UPPER) {
    intersection () {
	translate (v = [-500, -500, 45])
	cube (size = [1000, 1000, 1000], center = false);
	nacelle ();
    }
} else {
    intersection () {
	translate (v = [-500, -500, -1000 + 45])
	    cube (size = [1000, 1000, 1000], center = false);
	nacelle ();
    }
}
