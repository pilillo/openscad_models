difference() {
    
    // main shape
    union(){
        translate([0, 0, 30])
            cylinder(h = 20, r1 = 20, r2 = 10);
        //cube(110, center=true);
        sphere(40);
        
        translate([0, 0, -45])
            cylinder(h = 20, r1 = 1, r2 = 20);
    }
    
    // shape 1 (inner sphere)
    sphere(38);
    
    // shape 2 (inner cylinders)
    translate([0, 0, 30])
        cylinder(h = 20, r1 = 18, r2 = 8);
    
    // shape 3 (windows)
    union(){
        translate([0, 0, -38])
        for(i = [ [  0,  0,   0],
                   [ 0, 0, 30],
                   [0, 0,  60],
                   [ 0, 0,  90],
                   [ 0, 0,  120],
                   [ 0, 0,  150],
            ])
            {
               rotate(i)
               cube([2, 40, 2], center = true);
            }

        translate([0, 0, -32])
        for(i = [ [  0,  0,   0],
                   [ 0, 0, 30],
                   [0, 0,  60],
                   [ 0, 0,  90],
                   [ 0, 0,  120],
                   [ 0, 0,  150],
            ])
            {
               rotate(i)
               cube([8, 60, 4], center = true);
            }

        translate([0, 0, -25])
        for(i = [ [  0,  0,   0],
                   [ 0, 0, 30],
                   [0, 0,  60],
                   [ 0, 0,  90],
                   [ 0, 0,  120],
                   [ 0, 0,  150],
            ])
            {
               rotate(i)
               cube([12, 80, 5], center = true);
            }

        translate([0, 0, -16])
        for(i = [ [  0,  0,   0],
                   [ 0, 0, 30],
                   [0, 0,  60],
                   [ 0, 0,  90],
                   [ 0, 0,  120],
                   [ 0, 0,  150],
            ])
            {
               rotate(i)
               cube([14, 80, 8], center = true);
           }

        for(i = [ [  0,  0,   0],
                   [ 0, 0, 30],
                   [0, 0,  60],
                   [ 0, 0,  90],
                   [ 0, 0,  120],
                   [ 0, 0,  150],
            ])
            {
               rotate(i)
               cube([18, 80, 20], center = true);
            }


        translate([0, 0, 16])
        for(i = [ [  0,  0,   0],
                   [ 0, 0, 30],
                   [0, 0,  60],
                   [ 0, 0,  90],
                   [ 0, 0,  120],
                   [ 0, 0,  150],
            ])
            {
               rotate(i)
               cube([14, 80, 8], center = true);
            }
            
        translate([0, 0, 25])
        for(i = [ [  0,  0,   0],
                   [ 0, 0, 30],
                   [0, 0,  60],
                   [ 0, 0,  90],
                   [ 0, 0,  120],
                   [ 0, 0,  150],
            ])
            {
               rotate(i)
               cube([12, 80, 5], center = true);
            }
        }
    }
