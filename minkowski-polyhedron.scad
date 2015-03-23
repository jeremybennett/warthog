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
		translate ( [ 15, 30, 40.055])
			roundedBox([35, 55, 100], 5, false);
		//fuselage 
		minkowski () {
			mypoly ();
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
	translate ( [-5, 55 + epsilon, 180]){
      rotate ([90,0,0])
			cylinder (h = 60, r = 1.5);
	}
	translate ( [35, 55 + epsilon, 180]){
      rotate ([90,0,0])
			cylinder (h = 60, r = 1.5);
	}
	translate ( [-5, 55 + epsilon, 230]){
      rotate ([90,0,0])
			cylinder (h = 60, r = 1.5);
	}
	translate ( [35, 55 + epsilon, 230]){
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
	translate ( [ 9, -10, 717 - epsilon]){	
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
	translate ( [ 10, 10, 567 - epsilon]){
		cube ( [10, 25, 15]);
	}
	//wing hole
	hull() {
   		translate([-50,-10,525]) 
			rotate ([0,90,0]) 
				cylinder(h = 130, r = 10);
   		translate([-50,-10,350]) 
			rotate ([0,90,0]) 
				cylinder(h = 130, r = epsilon);
   		translate([-50,-10,540]) 
			rotate ([0,90,0]) 
				cylinder(h = 130, r = epsilon);
	}

};
