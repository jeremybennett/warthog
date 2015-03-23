//print at 5.274 to the xz plane
include <MCAD/boxes.scad>
include <MCAD/materials.scad>
include <MCAD/regular_shapes.scad>

module mypoly () {
	color (Stainless)
		polyhedron (
			points = [ 
		                       [  0.0,   0.0,   0.0],   	// P0, right bottom   rear
		                       [ 30.0,   0.0,   0.0],	   // P1,  left bottom   rear
		                       [ 30.0,  40.0,   0.0],    	// P2,  left    top   rear
		                       [  0.0,  40.0,   0.0],	   // P3, right    top   rear
		                       [-25.0,   0.0, 650.0],	   // P4, right bottom middle
		                       [ 55.0,   0.0, 650.0],   	// P5,  left bottom middle
		                       [ 55.0, 100.0, 650.0],   	// P6,  left    top middle
		                       [-25.0, 100.0, 650.0],	   // P7, right    top middle
		                       [  5.0,  40.0, 850.0],	   // P8, right         front
		                       [ 25.0,  40.0, 850.0], 	   // P9,  left         front
		                       [ 15.0,  20.0, -30.0], ], 	// P10,               tail
		            faces = [ [1, 0, 3, 2],
		                      [0, 1, 5, 4],
		                      [2, 3, 7, 6],
		                      [3, 0, 4, 7],
		                      [1, 2, 6, 5],
		                      [9, 8, 4, 5],
		                      [8, 9, 6, 7],
		                      [9, 5, 6],
		                      [8, 7, 4]
 ]);
}

epsilon = 0.001;
difference() {
union(){
intersection (){
	union() {
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
		translate ( [ 15, 30, 40])
			roundedBox([35, 55, 100], 5, false); 
		minkowski () {
			mypoly ();
				sphere(r = 10);
		};
	}
union(){
	//Battery compartment
	translate ( [ 2.5, 30, 200]){
		cube ( [25, 130, 360]);
	}
	translate ( [ 2.5, 30, 560]){
		cube ( [25, 34, 220]);
	}

	//Rx compartment
	translate ( [ -7, 5, 500]){
		cube ( [44, 230, 67]);
	}
}
		translate ( [ -20, 17, 0])
			rotate ([-5.274,0,0])
				cube ( [500, 500, 1500]);
};
	//battery cover clip holes
	translate ( [ -10, 90.5, 550]){
		cube ( [50, 4, 15]);
	}
	translate ( [ 0, 65.5, 280]){
		cube ( [30, 4, 15]);
	}
	translate ( [ -8, 99, 550]){
		cube ( [46, 1, 15]);
	}
	translate ( [ 2, 74, 280]){
		cube ( [26, 1, 15]);
	}
}
	translate ( [ -5, 72, 545]){
		cube ( [6, 35, 25]);
	}
	translate ( [ 29, 72, 545]){
		cube ( [6, 35, 25]);
	}
	translate ( [-10, 72, 545]){
		cube ( [11, 35, 2]);
	}
	translate ( [ 5, 47, 275]){
		cube ( [6, 35, 25]);
	}
	translate ( [ 19, 47, 275]){
		cube ( [6, 35, 25]);
	}
	translate ( [0, 47, 275]){
		cube ( [11, 35, 2]);
	}
	translate ( [0, 47, 299]){
		cube ( [11, 35, 2]);
	}
	translate ( [19, 47, 275]){
		cube ( [11, 35, 2]);
	}
	translate ( [19, 47, 299]){
		cube ( [11, 35, 2]);
	}
	translate ( [-20, 83.3, 211.7]){
		rotate ([45,0,0])
			cube ( [70, 30, 40]);
	}
	translate ( [-10, 30, 190]){
		cube ( [50, 65, 60]);
	}
//		translate ( [-13.2, 47, 224])
//			rotate ([0,10,0])
//				cube ( [15, 50, 55]);
//		translate ( [28.6, 47, 221])
//			rotate ([0,-10,0])
//				cube ( [15, 50, 55]);
//		translate ( [-23.2, 72, 494])
//			rotate ([0,10,0])
//				cube ( [15, 50, 55]);
//		translate ( [38.6, 72, 491])
//			rotate ([0,-10,0])
//				cube ( [15, 50, 55]);
};