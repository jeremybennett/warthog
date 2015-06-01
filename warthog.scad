// Overall Warthog Model

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


// Possible vertical offsets for slice
SL0 = -10;
SL1 =  70;
SL2 = 170;                      // Start of engine crossbar
SL3 = 270;
SL4 = 370;
SL5 = 470;
SL6 = 570;
SL7 = 670;
SL8 = 770;
SL9 = 870;

// Offsets for slice
SLICE_OFF    = SL1;
SLICE_HEIGHT = SL2 - SLICE_OFF;

// Slice for general intersections
module slice () {
    translate (v = [0, 0, SLICE_HEIGHT / 2 + SLICE_OFF])
        cube (size = [1000, 10000, SLICE_HEIGHT], center = true);
}


// Polyhedron defining the main hull shape
module fuselage_poly () {
    polyhedron (
        points = [ [  0.0,   0.0,   0.0],       // P0, right bottom   rear
                   [ 30.0,   0.0,   0.0],       // P1,  left bottom   rear
                   [ 30.0,  40.0,   0.0],       // P2,  left    top   rear
                   [  0.0,  40.0,   0.0],       // P3, right    top   rear
                   [-25.0,   0.0, 650.0],       // P4, right bottom middle
                   [ 55.0,   0.0, 650.0],       // P5,  left bottom middle
                   [ 55.0, 100.0, 650.0],       // P6,  left    top middle
                   [-25.0, 100.0, 650.0],       // P7, right    top middle
                   [  5.0,  40.0, 850.0],       // P8, right         front
                   [ 25.0,  40.0, 850.0],       // P9,  left         front
                   [ 15.0,  20.0, -30.0], ],    // P10,               tail
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


// Cross bar we will be connecting to (to make a suitable surface)
module crossbar () {
    intersection () {
        // crossbar
        hull () {
             translate (v = [-50, 61, 222])
                 rotate (a = [0, 90, 0])
                     cylinder (h = 130, r = 6);
             translate (v = [-50, 61, 230])
                 rotate (a = [0, 90, 0])
                     cylinder(h = 130, r = EPS);
             translate (v = [-30, 55, 170])
                 rotate (a = [0, 90, 0])
                     cylinder (h = 90, r = EPS);
             translate (v = [-5, 65, 170])
                 rotate (a = [0, 90, 0])
                     cylinder (h = 40, r = EPS);
        };
        // Edges.  Because we are off-center, this will be -27 to the left
        // and + 57 to the right (i.e on the X axis)
        translate (v = [15, 0, 0])
             cube (size = [84, 1000, 1000], center = true);
        slice ();
    }
}


// Flat plate for the tail
module tailplate () {
    intersection () {
        slice ();
        //tailplate
        translate (v = [15, 30, 40.055])
            roundedBox ([35, 55, 100], 5, false);
    }
}


// A single horizontal bar 3mm x 3mm between two points at a height

// It is assumed that the Z coordinate of the second point are the same as
// the first.

// @param pt1    coords (3D) of start
// @param pt2    coords (3D) of end
module cross_brace (pt1 = [0, 0, 0], pt2 = [1, 1, 0]) {
    // Sort out the point order.  First point has lower X value.
    z_off = pt1[2];
    pta = pt1[0] < pt2[0] ? [pt1[0], pt1[1]] : [pt2[0], pt2[1]];
    ptb = pt1[0] < pt2[0] ? [pt2[0], pt2[1]] : [pt1[0], pt1[1]];
    //echo (pt1, pt2, pta, ptb, z_off);
    translate (v = [0, 0, z_off + EPS])
	difference () {
	    // The actual brace
            linear_extrude (height = 3, slices = 1, center = false,
			    convexity = 10) {
                if (ptb[1] > pta[1]) {
    		    // Sloping up from left to right
		    polygon ( points = [ pta + [-1.5,  1.5],
					 ptb + [-1.5,  1.5],
					 ptb + [ 1.5, -1.5],
					 pta + [ 1.5, -1.5]]);
                } else {
    		    // Sloping down from left to right
                    polygon ( points = [ pta + [-1.5, -1.5],
					 ptb + [-1.5, -1.5],
					 ptb + [ 1.5,  1.5],
					 pta + [ 1.5,  1.5]]);
                }
            }
	    // Remove a hole from each end, since generally we'll be attaching
	    // to a lug.
	    translate (v = [pta[0], pta[1], 0])
		cylinder (h = 3 + EPS, r = (5.5 + 0.6) / 2, center = false);
	    translate (v = [ptb[0], ptb[1], 0])
		cylinder (h = 3 + EPS, r = (5.5 + 0.6) / 2, center = false);
    }
}


// Wall braces

// These are vertical or diagonal braces.  We need to construct a plane 3mm
// thick intersecting 4 points.  Clearly this might not be possible (3 points
// define a plane).  So we just use the first three points.  We need to extend
// past the first two points, but once we have the formula for the plane, that
// is easy to do.

// @param pt1  3D position (vector) of first point
// @param pt2  3D position (vector) of second point
// @param pt3  3D position (vector) of third point
module wall_brace (pt1, pt2, pt3) {
    // Extend the first two points
    pt1e = pt1 * 2 - pt3;
    pt2e = pt2 * 2 - pt3;
    // Build polygon 1.5mm above and below polygon defined by pt1e, pt2e and
    // pt3. Use the cross product to find the perpendicular, then normalize
    // and multiply by the length.
    echo ("pt1e - pt3", pt1e - pt3);
    echo ("pt2e - pt3", pt2e - pt3);
    normal = cross (pt1e - pt3, pt2e - pt3);
    off = (normal / norm (normal)) * 1.5;
    echo ("normal", normal);
    echo ("offset", off);
    difference () {
	intersection () {
	    polyhedron (
		points = [ pt1e + off, pt2e + off, pt3 + off,	// Upper plane
			   pt1e - off, pt2e - off, pt3 - off],   // Lower plane
		faces = [ [2, 1, 0],
			  [3, 4, 5],
			  [1, 4, 3, 0],
			  [2, 5, 4, 1],
			  [0, 3, 5, 2] ]);
	    slice ();
	    fuselage_outer ();
	}
	fuselage_very_inner ();
    }
}


// Lug body.  Lug is designed to be sliced in half.  Lower part must have a
// steep enough slope to be printable.

// @param dir  2D vector, first element 1 to mirror in X direction, 0
//             otherwise, second element 1 to mirror in Y direction, 0
//             otherwise.
module lug_body (dir = [0, 0]) {
    // Mirror as instructed
    mirror ([dir[0], dir[1], 0])
        // Translate lug, so center of hole is on origin
        translate (v = [-sqrt(8), -sqrt(8), 0])
            // Slice off the top of the lug to make it horizontal
            intersection () {
                translate (v = [0, 0, -500])
                    cube (size = [1000, 1000, 1000], center = true);
                // Rotate the lug
                rotate (a = [0, -15, 45]) {
                    // Translate lug to be adjacent to Y axis
                    translate (v = [4, 0, -50])
                        cylinder (r = 4, h = 100, center = true, $fn = 24);
                    translate (v = [6, 0, -50])
                        cube (size = [4, 8, 100], center = true);
                };
            }
}


// Full lug, with nut on top, and bolt below

// @param pt  3D vector location of hole center
module lug (pt) {
    dir = [pt[0] > 0 ? 0 : 1, pt[1] > 0 ? 0 : 1];
    // M3 head/nut radius 5.5mm + 0.6mm clearance
    head_r = (5.5 + 0.6) / 2;
    // M3 shank radius 3.0mm + 0.6mm clearance
    shank_r = (3.0 + 0.6) / 2;
    loc = pt + [0, 0, 3];
    translate (v = loc)
        difference () {
            lug_body (dir);
            translate (v = [0, 0, -1.5])
                cylinder (r = head_r, h = 2, center = false, $fn = 6);
            // Screw shank + 0.6 for gap
            cylinder (r = shank_r, h = 200, center = true, $fn = 24);
            // Screw head 5.5 + 0.6 for gap at bottom
            translate (v = [0, 0, -106])
                cylinder (r = head_r, h = 100, center = false, $fn = 6);
        }
}


// All the support structures.  Central to this are the lug points where the
// sections connect.
module all_supports () {
    // Vector of lug points.  These are the centers of lug holes.  One vector
    // for each layer.  That vector comprises four lug centers and a vertical
    // position.
    lugs = [[[ -2.0,  -2.0, SL0],
             [ 31.5,  -2.0, SL0],
             [ -2.0,  41.0, SL0],
             [ 32.5,  41.0, SL0]],
            [[ -6.0,  -4.0, SL1],
             [ 36.0,  -4.0, SL1],
             [ -6.0,  50.0, SL1],
             [ 36.0,  50.0, SL1]],
            [[ -9.0,  -3.5, SL2],
             [ 39.5,  -3.5, SL2],
             [ -9.0,  60.0, SL2],
             [ 39.5,  60.0, SL2]],
            [[-13.0,  -4.0, SL3],
             [ 43.5,  -4.0, SL3],
             [-13.0,  69.0, SL3],
             [ 43.5,  69.0, SL3]],
            [[-16.0,  -4.0, SL4],
             [ 47.0,  -4.0, SL4],
             [-16.0,  77.0, SL4],
             [ 47.0,  77.0, SL4]],
            [[-19.0,  -3.5, SL5],
             [ 50.0,  -3.5, SL5],
             [-20.0,  86.0, SL5],
             [ 51.0,  86.0, SL5]],
            [[-23.0,  -3.0, SL6],
             [ 54.0,  -3.0, SL6],
             [-24.0,  95.0, SL6],
             [ 54.0,  95.0, SL6]],
            [[-23.0,  -3.0, SL7],
             [ 54.0,  -3.0, SL7],
             [-24.0,  95.0, SL7],
             [ 54.0,  95.0, SL7]]];
    intersection () {
	slice ();
        fuselage_outer ();
	for (row = [0 : len (lugs) - 1]) {
	    sl  = lugs[row][4];
	    // Save some computation if we can't possibly be in this slice
	    if ((lugs[row][0][2] >= (SLICE_OFF - EPS)) &&
		(lugs[row][0][2] <= (SLICE_OFF + SLICE_HEIGHT))) {
		 pt0 = lugs[row][0];		// Current slice
		 pt1 = lugs[row][1];
		 pt2 = lugs[row][2];
		 pt3 = lugs[row][3];
		 pt4 = lugs[row + 1][0];	// Slice above
		 pt5 = lugs[row + 1][1];
		 pt6 = lugs[row + 1][2];
		 pt7 = lugs[row + 1][3];
		 lug (pt0);
		 lug (pt1);
		 lug (pt2);
		 lug (pt3);
		 cross_brace (pt0, pt3);
		 cross_brace (pt2, pt1);
		 wall_brace (pt0, pt4, pt3);
		 wall_brace (pt3, pt7, pt0);
		 wall_brace (pt2, pt6, pt1);
		 wall_brace (pt1, pt5, pt2);
		 wall_brace (pt0, pt5, (pt2 + pt3 + pt6 + pt7) / 4);
		 wall_brace (pt1, pt4, (pt2 + pt3 + pt6 + pt7) / 4);
		 wall_brace (pt2, pt7, (pt0 + pt1 + pt4 + pt5) / 4);
		 wall_brace (pt3, pt6, (pt0 + pt1 + pt4 + pt5) / 4);
		 wall_brace (pt0, pt6, (pt1 + pt3 + pt5 + pt7) / 4);
		 wall_brace (pt2, pt4, (pt1 + pt3 + pt5 + pt7) / 4);
		 wall_brace (pt1, pt7, (pt0 + pt2 + pt4 + pt6) / 4);
		 wall_brace (pt3, pt5, (pt0 + pt2 + pt4 + pt6) / 4);
	    }
	}
    }
}


// The fuselage as solid, sharp-edged box
module fuselage_solid () {
    intersection () {
        union () {
            // Fuselage polygon
            fuselage_poly ();

            // canopy
            translate (v = [20, 85, 665])
                rotate (a = [50,0,0])
                    roundedBox ([45, 90, 90], 15, false);
        };
        slice ();
    }
}


// Outer skin of fuselage
module fuselage_outer () {
    minkowski () {
        fuselage_solid ();
        sphere(r = 10);
    }
}


// Inner skin of fuselage
module fuselage_inner () {
    minkowski () {
        fuselage_solid ();
        sphere(r = 9.6);
    }
}


// Inner shell of fuselage for ribs
module fuselage_very_inner () {
    minkowski () {
        fuselage_solid ();
        sphere(r = 7);
    }
}


// Fuselage shell by differencing inner skin from outer
module fuselage_shell () {
    intersection () {
        difference () {
            union () {
                fuselage_outer ();
                crossbar ();
                tailplate ();
            };
            minkowski () {
                fuselage_inner ();
            }
        };
        slice ();
    }
}


// Fuselage is shell with additions and cutouts
module fuselage () {
    union () {
        fuselage_shell ();
	all_supports ();
    }
}

translate (v = [0, 0, -SLICE_OFF])
    fuselage ();


module the_rest () {
difference (){
        union() {
        // Gun barrel
                translate ( [ 15, 10, 840]){
                        cylinder (h = 5, r = 17);
                }
                translate ( [ 15, 10, 740]){
                        cylinder (h = 5, r = 17);
                }
                translate ( [ 15, 10, 790]){
                        cylinder (h = 5, r = 17);
                }
                translate ( [ 15, 10, 650]){
                        cylinder (h = 200, r = 15);
                }
                //canopy
                translate ( [ 15, 80, 660])
                        rotate ([50,0,0])
                                roundedBox([55, 100, 100], 25, false);
                //tailplate
                translate ( [ 15, 30, 40.055])
                        roundedBox([35, 55, 100], 5, false);
                //fuselage_poly
                minkowski () {
                        fuselage_poly ();
                                sphere(r = 10);
                };
        }
        //Battery compartment
        translate ( [ 2.5, 30, 200]){
                cube ( [25, 130, 360]);
        }
        translate ( [ 2.5, 30, 560]){
                cube ( [25, 34, 220]);
        }
        //Engine bridge mount
        translate ( [-20, 55, 170]){
                cube ( [70, 30, 70]);
        }
        //anti overhang thingamy
        translate ( [-20, 83.3, 211.7]){
                rotate ([45,0,0])
                        cube ( [70, 30, 40]);
        }
        //Engine bridge screw holes
        translate ( [-5, 55 + EPS, 180]){
      rotate ([90,0,0])
                        cylinder (h = 60, r = 1.5);
        }
        translate ( [35, 55 + EPS, 180]){
      rotate ([90,0,0])
                        cylinder (h = 60, r = 1.5);
        }
        translate ( [-5, 55 + EPS, 230]){
      rotate ([90,0,0])
                        cylinder (h = 60, r = 1.5);
        }
        translate ( [35, 55 + EPS, 230]){
      rotate ([90,0,0])
                        cylinder (h = 60, r = 1.5);
        }
        //elevator servo hole
        translate ( [ 9, 20, 100]){
                rotate ([-5.274,0,0])
                        cube ( [12, 143, 23]);
        }
        //aileron servo hole
        translate ( [ 9, -10, 630]){
                cube ( [12, 53, 23]);
        }
        //nose wheel mounting hole hole
        translate ( [ 9, -10, 717 - EPS]){
                cube ( [12, 53, 23]);
        }
        //Rx compartment
        translate ( [ -7, 5, 500]){
                cube ( [44, 230, 67]);
        }
        //gun barrel
        translate ( [ 15, 10, 500])
                cylinder (h = 350, r = 10);
        //battery cover clip holes
        translate ( [ -10, 90, 550]){
                cube ( [50, 5, 15]);
        }
        translate ( [ -10, 98, 550]){
                cube ( [50, 5, 15]);
        }
        translate ( [ 0, 65, 280]){
                cube ( [30, 5, 15]);
        }
        translate ( [ 0, 73, 280]){
                cube ( [30, 5, 15]);
        }
        //aileron servo wire hole
        translate ( [ 10, 10, 567 - EPS]){
                cube ( [10, 25, 15]);
        }
        //wing hole
        hull() {
                translate([-50,-10,525])
                        rotate ([0,90,0])
                                cylinder(h = 130, r = 10);
                translate([-50,-10,350])
                        rotate ([0,90,0])
                                cylinder(h = 130, r = EPS);
                translate([-50,-10,540])
                        rotate ([0,90,0])
                                cylinder(h = 130, r = EPS);
        }

};
}
