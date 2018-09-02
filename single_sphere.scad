difference(){
    union(){
        translate([0, 0, 50]) cylinder(h=2,r1=20, r2=20);
        translate([0, 0, 30]) cylinder(h=20,r1=23, r2=20);
        //translate([0, 0, 40]) sphere(r = 40);
        translate([0, 0, -2]) sphere(r = 40);
    }
 
    union(){
        translate([0, 0, 50]) cylinder(h=3,r1=16, r2=16);
        translate([0, 0, 30]) cylinder(h=21,r1=22, r2=19);
        
        //translate([0, 0, 40]) sphere(r = 39);
        translate([0, 0, -2]) sphere(r = 39);        
        translate([0, 0, -48]) sphere(r = 40);
    }
}