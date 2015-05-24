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
difference (){
	union (){
		intersection (){
			minkowski () {
				mypoly ();
					sphere(r = 10);
			};
			union () {
				//Engine bridge mount plate
				translate ( [-20, 55, 170]){
					cube ( [70, 30, 70]);
				}
				//anti overhang thingamy
				translate ( [-20, 83.3, 211.7]){
					rotate ([45,0,0])
						cube ( [70, 30, 40]);
				}
			}
		}
		//crossbar
		hull() {
   			translate([-50,61,222]) 
				rotate ([0,90,0]) 
					cylinder(h = 130, r = 6);
   			translate([-50,61,230]) 
				rotate ([0,90,0]) 
					cylinder(h = 130, r = epsilon);
   			translate([-30,55,170]) 
				rotate ([0,90,0]) 
					cylinder(h = 90, r = epsilon);
   			translate([-5,65,170]) 
				rotate ([0,90,0]) 
					cylinder(h = 40, r = epsilon);
		}
		//nacelles
		hull () {
   			translate([-60,61,150]) {
				rotate ([-5,0,0]) 
					cylinder(h = 150, r = 30);}
   			translate([-60,67.124,220]) {
				rotate ([-5,0,0]) 
					cylinder(h = 60, r = 33);}}
		hull () {
   			translate([90,61,150]) {
				rotate ([-5,0,0]) 
					cylinder(h = 150, r = 30);}		
   			translate([90,67.124,220]) {
				rotate ([-5,0,0]) 
					cylinder(h = 60, r = 33);}}
		
}
;
	//Engine bridge screw holes
	translate ( [-5, 85, 180]){
      rotate ([90,0,0])
			cylinder (h = 60, r = 2.5);
	}
	translate ( [35, 85, 180]){
      rotate ([90,0,0])
			cylinder (h = 60, r = 2.5);
	}
	translate ( [-5, 85, 230]){
      rotate ([90,0,0])
			cylinder (h = 60, r = 2.5);
	}
	translate ( [35, 85, 230]){
      rotate ([90,0,0])
			cylinder (h = 60, r = 2.5);
	}
	//cable holes
	translate ( [-55, 61, 222]){
      rotate ([0,90,0])
			cylinder (h = 140, r = 5);
}
	hull() {
		translate ( [10, 61, 222]){
      		rotate ([90,0,0])
				cylinder (h = 60, r = 5);
}
		translate ( [20, 61, 222]){
      		rotate ([90,0,0])
				cylinder (h = 60, r = 5);
}
}
		//nacelles
   			translate([-60,61,150 - epsilon]) {
				rotate ([-5,0,0]) 
					cylinder(h = 160, r = 27.5);}
   			translate([90,61,150 - epsilon]) {
				rotate ([-5,0,0]) 
					cylinder(h = 160, r = 27.5);}		
}