WHEEL_DIAM = 30;
WHEEL_WIDTH = 12;
AXLE_DIAM = 2;
HOLE_DIAM = 9;

difference () {
	union () {
		rotate_extrude(convexity = 10)
			translate([20, 0, 0])
				circle(r = 8); 
		translate([0, 0, -5])
			cylinder (h = 10, r = 20);
	};
	rotate ([0,90,0]){
	rotate ([0,90,0])
		translate([ 0, 0, -(WHEEL_WIDTH + 1)/2])
			cylinder(h = WHEEL_WIDTH + 1, d = AXLE_DIAM);
	rotate ([0,90,0])
		translate([ 0, 3 * WHEEL_WIDTH/5, -(WHEEL_WIDTH + 1)/2])
			cylinder(h = WHEEL_WIDTH + 1, d=HOLE_DIAM);
	rotate ([0,90,0])
		translate([ 0, - 3 * WHEEL_WIDTH/5, -(WHEEL_WIDTH + 1)/2])
			cylinder(h = WHEEL_WIDTH + 1, d=HOLE_DIAM);
	rotate ([0,90,0])
		translate([ 3 * WHEEL_WIDTH/5, 0, -(WHEEL_WIDTH + 1)/2])
			cylinder(h = WHEEL_WIDTH + 1, d=HOLE_DIAM);
	rotate ([0,90,0])
		translate([ - 3 * WHEEL_WIDTH/5, 0, -(WHEEL_WIDTH + 1)/2])
			cylinder(h = WHEEL_WIDTH + 1, d=HOLE_DIAM);
	}
};