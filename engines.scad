// Engines for Warthog Model

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

module mypoly () {
    color (Stainless)
        polyhedron (
            points = [ [  0.0,   0.0,   0.0],      // P0, right bottom   rear
                       [ 30.0,   0.0,   0.0],      // P1,  left bottom   rear
                       [ 30.0,  40.0,   0.0],      // P2,  left    top   rear
                       [  0.0,  40.0,   0.0],      // P3, right    top   rear
                       [-25.0,   0.0, 650.0],      // P4, right bottom middle
                       [ 55.0,   0.0, 650.0],      // P5,  left bottom middle
                       [ 55.0, 100.0, 650.0],      // P6,  left    top middle
                       [-25.0, 100.0, 650.0],      // P7, right    top middle
                       [  5.0,  40.0, 850.0],      // P8, right         front
                       [ 25.0,  40.0, 850.0],      // P9,  left         front
                       [ 15.0,  20.0, -30.0], ],   // P10,               tail
	   faces = [ [1, 0, 3, 2],
                     [0, 1, 5, 4],
                     [2, 3, 7, 6],
                     [3, 0, 4, 7],
                     [1, 2, 6, 5],
                     [9, 8, 4, 5],
                     [8, 9, 6, 7],
                     [9, 5, 6],
                     [8, 7, 4] ]);
}


// The main engine block

module engine () {
    difference () {
        union () {
	    // section of main fuselage
            intersection () {
		minkowski () {
                    mypoly ();
                    sphere(r = 10);
		};
		union () {
		    //Engine bridge mount plate
		    translate (v = [-20, 55, 170]) {
			cube (size = [70, 30, 70]);
		    }
		    //anti overhang thingamy
		    translate (v = [-20, 83.3, 211.7]) {
			rotate (a = [45,0,0])
                        cube (size = [70, 30, 40]);
		    }
		}
            }

	    // crossbar
	    hull () {
		translate (v = [-50,61,222])
		    rotate (a = [0,90,0])
		        cylinder (h = 130, r = 6);
		translate (v = [-50,61,230])
		    rotate (a = [0,90,0])
		        cylinder(h = 130, r = EPS);
		translate (v = [-30,55,170])
		    rotate (a = [0,90,0])
		        cylinder (h = 90, r = EPS);
		translate (v = [-5,65,170])
		    rotate (a = [0,90,0])
		        cylinder (h = 40, r = EPS);
	    }

	    // nacelles
	    hull () {
		translate (v = [-60,61,150]) {
		    rotate (a = [-5,0,0])
		        cylinder (h = 150, r = 30, $fn = 180);
		}
		translate (v = [-60,67.124,220]) {
		    rotate (a = [-5,0,0])
		        cylinder(h = 60, r = 33, $fn = 180);
		}
	    }
	    hull () {
		translate(v = [90,61,150]) {
		    rotate (a = [-5,0,0])
		        cylinder(h = 150, r = 30, $fn = 180);
		}
		translate(v = [90,67.124,220]) {
		    rotate (a = [-5,0,0])
		        cylinder(h = 60, r = 33, $fn = 180);
		}
	    }
	};

	// engine bridge screw holes
	translate (v = [-5, 85, 180]) {
	    rotate ([90,0,0])
                cylinder (h = 60, r = 2.5);
	}
	translate (v = [35, 85, 180]){
	    rotate (a = [90,0,0])
                cylinder (h = 60, r = 2.5);
	}
	translate (v = [-5, 85, 230]){
	    rotate (a = [90,0,0])
                cylinder (h = 60, r = 2.5);
	}
	translate ( [35, 85, 230]){
	    rotate ([90,0,0])
                cylinder (h = 60, r = 2.5);
	}

	// cable holes
	translate (v = [-55, 61, 222]){
	    rotate (a = [0,90,0])
                cylinder (h = 140, r = 5);
	}
	hull() {
	    translate (v = [10, 61, 222]){
		rotate (a = [90,0,0])
		    cylinder (h = 60, r = 5);
	    }
	    translate (v = [20, 61, 222]) {
		rotate (a = [90,0,0])
		    cylinder (h = 60, r = 5);
	    }
	}

	// nacelles
        translate (v = [-60,61,150 - EPS]) {
            rotate ([-5,0,0])
                cylinder(h = 160, r = 27.5);
	}
        translate (v = [90,61,150 - EPS]) {
            rotate (a = [-5,0,0])
                cylinder (h = 160, r = 27.5);
	}
    }
}

translate (v = [0, 0, -150])
    engine ();
