$fn=50;
					
difference() {
	rotate_extrude(angle=360) {
		translate([7.5,0]) {
			circle(d=2.2);
		}
	}

	translate([0,0,-1.40]) {
		rotate_extrude(angle=360) {
			translate([7.5,0]) {
				square(size=[2.2,2], center=true);
			}
		}
	}
}

