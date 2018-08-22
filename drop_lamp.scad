difference(){
    
    intersection(){
        // main shape
        union() {
          sphere(r = 20);
          translate([0, 0, 20 * sin(30)])
            cylinder(h = 30, r1 = 20 * cos(30), r2 = 1);
        }


    }
    // inner sphere
    sphere(r = 19.5);
    
    // bottom cut
    translate([0, 0, -20])
        sphere(r = 19.5);
    
    // top cut
    translate([0, 0, sin(28)])
        cylinder(h = 38, r1 = 19, r2 = 1);

    translate([0, 0, 5])
        cylinder(h = 28, r1 = 18.5, r2 = 4);
    
    //translate([0, 0, 20])
    //    cylinder(h = 20, r1 = 10, r2 = 1);
    
    // inner cilinder for lamp holder
    translate([0, 0, 23])
        cylinder(h = 8, r1 = 5, r2 = 5);

    // wire hole
    translate([0, 0, 30])
        cylinder(h = 15, r1 = 2, r2 = 2);

    // light holes
    rotate([45, 0, 0])
        //translate([-20, 0, 0])
        translate([-20, 0, 0])
            cube([40, 1, 40]);

    /*
    rotate([45, 0, 0])
        translate([0, 10, -20])
            cube([40, 3, 40]);
            */
    translate([-9.5, 0, 0])
        circular_text(); 
}


/*
//rotate([45, 0, 0])
translate([15, 15]) {
   text("OpenSCAD", font = "Liberation Sans");
 }
*/

/*
linear_extrude(height = 100, center = true, convexity = 10, twist = 3600, scale=[1,1])
translate([2, 0, 0])
circle(r = 20);
*/

/*
translate([0, 0, 23])
    cylinder(h = 10, r1 = 5, r2 = 5);
*/



// to define text -------------------------------------
// http://forum.openscad.org/It-seems-no-way-to-put-text-on-the-curved-surface-td20182.html
radius = 20; 
height = 30; 
slices = 18; 

// http://upli.st/l/list-of-all-ascii-emoticons
txt = "● ᴥ ●"; 
text_depth = 20; 

circumference = 3 * 3.14159 * radius; 
slice_width = circumference / slices; 

module circular_text () { 
    
    union () { 
    
        for (i = [0:1:slices]) { 
            
            rotate ([0,0,i*(360/slices)]) translate ([0,-radius,0]) intersection () { 
                
                translate ([-slice_width/2 - (i*slice_width) ,0 ,0]) rotate ([90,0,0]) 
                linear_extrude(text_depth, center = true, convexity = 10) 
                text(txt); 
                
                cube ([slice_width+0.1, text_depth+0.1, height], true); 
            } 
        } 
    } 
} 

   