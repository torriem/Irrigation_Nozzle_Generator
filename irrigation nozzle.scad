$fn=50;
/* If using command line, use -D 'model="xxx"' where xxx is one of
   iwob, iwob2, or nelson.  Use -D 'size=##' to set the size, using
   standard iwob and nelson size numbers.abs
 */
nozzle_tolerance = 0.12; //mm over-size nozzle hole

font =  "Arial Narrow";
model = "nelson"; //set this to iwob2, iwob, or nelson
size = 16;
nelson_size = 36;

if (model == "iwob2") {
	iwob2_nozzle(size);
} else if (model == "iwob") {
	iwob_nozzle(size);
} else if (model == "nelson") {
	nelson_nozzle(nelson_size);
} else {
	//otherwise comment out what you don't want, and set the size
	//number in the example calls below:

	iwob2_nozzle(size);
	translate([0,-25, 0])
		iwob_nozzle(size);

	translate([0,25,0])
		nelson_nozzle(nelson_size);
}

//Create an iWob nozzle of a given size, which is
//in 64ths of an inch.  Compatible with original
//iWob sprinklers
module iwob_nozzle(nozzle_number) {
	nozzle_radius = (nozzle_number / 64.0 * 25.4 + nozzle_tolerance) / 2;
	difference () {
		//Outside of nozzle
		union() {
			cylinder(11.5,9.25,9.25); //base
			translate([0,0,11.5]) {
				cylinder(21.75,7.5,5.85); //taper
			}
			translate([0,0,33.25]) {
				cylinder(h=9.5,r=5.85); //nozzle part
			}
		}

		//nozzle hole through the center of nozzle
		union() {
			translate([0,0,-1]) {
				cylinder(11.55,7.25,5.25);
			}
			translate([0,0,10.5]) {
				cylinder(27.25,5.25,nozzle_radius);
			}
			translate([0,0,37.74]) {
				cylinder(h=6, r=nozzle_radius);
			}
		}

		//Add nozzle number text
		RADIUS=9.25;
		stext = (nozzle_number < 10 ? str("0",nozzle_number) : str(nozzle_number));
		chars = len( stext );
		ARC_ANGLE=(chars > 2 ? 120 : 65);

		translate([0,0,6]) {
			for(i=[0:1:chars]){
				rotate([0,0,i*ARC_ANGLE/chars]){
					translate( [RADIUS*.94,0,0])
						rotate([90,0,90])
						linear_extrude(1)
							offset(r=0.01) //offset fixes bad font outlines
								text(stext[i],size=7,font=font, valign="center",halign="center");
				}
			}
		}
	}
}

module iwob2_nozzle(nozzle_number) {
	nozzle_radius = (nozzle_number / 64.0 * 25.4 + nozzle_tolerance) / 2;

	difference() {
		union() {
			nozzle_outer();
			translate([0,0,13.4])
				pivot_feature();
			keeper1();
		}
		union() {
			translate([0,0,-1])
				cylinder(6.01,nozzle_radius,nozzle_radius);
			translate([0,0,5])
				cylinder(15.01,nozzle_radius,5);
		}
		nozzle_text();           
	}
	//nozzle_text();           

	module nozzle_text() {

		/*
		   nozzle_string = (nozzle_number - floor(nozzle_number)) > 0.1 
		   ? str(floor (nozzle_number / 10), ".", 
		   floor (nozzle_number - floor (nozzle_number / 10)  * 10)) 
		   : str(nozzle_number);
		 */
		/*
		   nozzle_string = (nozzle_number - floor(nozzle_number)) > 0.1 
		   ? str(floor (nozzle_number))
		   : str(nozzle_number);
		 */
		nozzle_string = str(nozzle_number);
		//echo (nozzle_string);

		translate([11.4,0,5]) {
			rotate([37+90,0,90]) {
				letter(nozzle_string,4,4);
			}
		}
	}


	module latch_fillet() {
		translate([10,0,15.5])
			rotate([90,0,0])
			cylinder(40,2,2, center = true);
	}
	module keeper_cut3() {
		translate([25-7.5,0,0])
			rotate([0,0,90])
			rotate([90,0,0])
			linear_extrude(7.5) {
				polygon( points = [ [-4.66,15], [-4.7-7,14.9], [-4.7-7,15+6] ]);
			}
	}

	module keeper_cut2() {
		l1 = 4.25;
		l2 = 8.8;

		linear_extrude(50) {
			polygon( points = [ [17.5,l1/2], [26.5,l2/2],
					[26.5,-l2/2], [17.5,-l1/2] ]);
		}

	}

	module keeper_cut1() {
		translate([0,20,0])
			rotate([90,0,0])
			linear_extrude(40) {
				polygon( points = [ [ 8,-0.01], [8+19,-0.01],
						[ 8+19,25] ]);
			}
	}

	module keeper3() {
		translate([0,0,15])
			linear_extrude(10) {
				polygon(points = [ [18,-3], [18+7,-3],
						[18+7, -11], [18,-9.5]
				]);
			}
	}

	module keeper2() {
		//locking tabs
		translate([12,0,0])
			rotate([90,0,0])
			rotate([0,90,0])
			linear_extrude(13) {
				//points taken from FreeCAD sketch and extruded
				polygon(points=[ [-2.5,13.5], [-4.625,13.5], 
						[-4.85,23], [-6.85,23],
						[-6.85,25], [-2.85,25]]); 
			}
	}

	module keeper1() {
		//Form the locking tabs
		difference() {
			union() {
				translate([5.904,-4.625,0]) {
					difference() {
						union(){
							cube([17.5,9.25,13.5]);
							translate([4,0,13.5])
								cube([2.2,9.25,2]);
						}
						translate([0,2.125,8])
							cube([18,5,8]);
					}
				}

				keeper2();
				mirror([0,1,0])
					keeper2();

				keeper3();
				mirror([0,1,0])
					keeper3();

			}

			keeper_cut1();
			keeper_cut2();

			keeper_cut3();
			mirror([0,1,0])
				keeper_cut3();

			latch_fillet();

		}
	}
	module nozzle_outer() {
		union() {
			cylinder(16,7.5,7.5);
			translate([0,0,16])
				cylinder(3,7.5,6.25);
		}
	}

	module pivot_feature() {
		pivot_width = 18.5;

		difference() {
			union() {
				//unclipped shape with rounded edge
				translate([-9.15,0,0])
					rotate([90,0,0])
					cylinder(pivot_width,2.35,2.35, center = true);

				translate([-2.075,0,0])
					cube([14.15,pivot_width,4.7], center = true);
			}


			translate([-6,0,-2.355]) { 
				//shape to trim with, rough tangent to circle
				difference() {
					union() {
						translate([9,-7.5,0]) {
							cube([10,15,4.8]);
						}

						translate([0,9.5,0]) {
							rotate([0,0,-15.85])
								cube([20,5,4.8]);
						}
						translate([0,-9.5,0]) {
							rotate([0,0,15.85]) {
								translate([0,-5,0])
									cube([20,5,4.8]);
							}
						}
					}
					translate([6,0,-1]) {
						cylinder(6,7.5,7.5);
					}
				}
			}
		}
	}
}

//generate a nelson-style nozzle of a given size,
//which is in 128ths of an inch
module nelson_nozzle(nelson_nozzle_number) {

	nozzle_radius = (nelson_nozzle_number / 128.0 * 25.4 + nozzle_tolerance) / 2;
	//echo (nelson_nozzle_number);
	//echo ("nozzle radius is ", nozzle_radius);
	difference() {
		//Outer shape

		union() {
			difference() {
				union() {
					cylinder(2.5,8.5,9);
					translate([0,0,2.5]) {
						cylinder(4.5,9,9);
					}
					/* large flat part where o-ring will sit */
					translate([0,0,7]) {
						cylinder(1.5,9,11.5);
					}
					translate([0,0,8.5]) {
						cylinder(4.25,11.5,11.5);
					}

				}

				/* cut out notches to mate with upper body threaded part */
				translate([0,0,9]) {
					translate([0,0,2.5]){
						union() {
							cube([56,9.5,5],center=true);
							rotate([0,0,90]) {
								cube([56,9.5,5],center=true);
							}
						}        
					}
				}
				/* o-ring channel */
				translate([0,0,9]) {
					rotate_extrude(angle=360) {
						translate([7.5,0]) {
							circle(d=2.5);
						}
					}
				}
				/* part that's inserted into upper body */
				translate([0,0,9]) {
					difference() {
						cylinder(4.25,8.75,8.75);
						cylinder(10,6.25,6.25, center=true);
					}        
				}
			}
			cylinder(21,6.25,6.25);
		}

		//inner nozzle
		union() {
			translate([0,0,-1]) {
				cylinder(7.1,nozzle_radius,nozzle_radius);
			}
			translate([0,0,6]) {
				cylinder(15.5,nozzle_radius,4.75);
			}
		}

		//Add nozzle number text
		RADIUS=9;
		stext = (nelson_size < 10 ? str("0",nelson_size) : str(nelson_size));
		chars = len( stext );
		ARC_ANGLE=55;

		translate([0,0,3.5]) {
			for(i=[0:1:chars]){
				rotate([0,0,i*ARC_ANGLE/chars]){
					translate( [RADIUS*.93,0,0])
						rotate([90,0,90])
						linear_extrude(1.5)
							offset(r=0.01) //offset fixes bad font outlines
								text(stext[i],size=6,font=font, valign="center",halign="center");
				}
			}
		}
		
	}
}

module letter(l, letter_size = 5, letter_height = 0.4) {
	// Use linear_extrude() to make the letters 3D objects as they
	// are only 2D shapes when only using text()
	linear_extrude(height = letter_height) {
		offset(r=0.01) //offset fixes bad font outlines
			text(l, size = letter_size, font = font, halign = "center", valign = "center", $fn = 16);
	}
}


