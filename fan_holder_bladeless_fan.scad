fan_type = "flat";

// global stuff
// 1) connection box size
height_in_top_cubicle   = 8; 
box_side            =   73;
box_height          =   70;
box_border_width    =   1.5;   
// 2) air holes
spacing             =   5;
fig_size            =   4;
fig_number_per_side =   15;
num_hole_layers     =   4;

// since the assignments would only e valid inside the bracket scope we got to comment the if out :(
/*
if (fan_type == "propeller"){
    // *** propeller-like fan ***
    motor_diameter      =   23;
    motor_height        =   30;

    fan_diameter        = 52;
    fan_height          = 20;
    fan_connection_height = 5;

    spacing             =   5;
    fig_size            =   4;
    fig_number_per_side =   12;
    num_hole_layers     =   4;

    fan_positioning     =   (box_height / 2) - (box_height / 6);
    support_disk_height =   5;
    support_disk_width  =   3;

    add_motor_holder_floor  = true; 
} else {
*/
    // *** flat fan PC-like ***
 
    // top connection + fan + filter block + legs
    // 1) top connection
    connection_box_height   = 10;
    
    // block_side = fan_diameter + box_border_width;
    
    // 2) fan block
    fan_diameter        = 80;
    fan_height          = 25;
    game                = 1;
    wire_hole_diameter = 5;
    
    // 3) filter block
    filter_side         = 80;
    filter_height       = 6;    // in 6 mm we should be able to place the filter
    
    // 4) leg block
    leg_box_height      = 4;
    leg_in_top_box      = 4;
    leg_width           = 4;
    leg_height          = 7;

    // fan positioning wrt main box
    fan_positioning     =   box_height / 2;
    
//}



module draw_holes(n_l, side){
    // draw the air holes
    for(h=[0:n_l-1]){
        for(f=[0:fig_number_per_side-1]){
            for(y=[0:1]){
                translate([spacing + f*spacing, y*side-(box_border_width/2), spacing/2 + h*spacing ])
                    cube([fig_size, box_border_width, fig_size]);
            }
                
            for(x=[0:1]){
                translate([x*side-(box_border_width/2), spacing+ f*spacing , spacing/2 + h*spacing])
                    cube([box_border_width, fig_size, fig_size]);
            }    
        }
    }
}

module cubicle(draw_legs = true){
    if(fan_type == "propeller"){
        // draw the cube
        difference(){
            cube(size = [box_side,box_side,box_height], center = false);
            translate([box_border_width/2, box_border_width/2, 0])
                cube(size = [box_side-box_border_width, box_side-box_border_width, box_height], center = false);        

            draw_holes(num_hole_layers, box_side);
        }

        // add a stand for the top cube
        translate([0,0, box_height-(height_in_top_cubicle+box_border_width)]){        
            difference(){
                cube(size = [box_side,box_side,box_border_width], center = false);
                
                translate([box_border_width, box_border_width, 0])
                    cube(size = [box_side-box_border_width*2, box_side-box_border_width*2, box_border_width], center = false);  
            }
        }
    }else{
        // 1) draw the connection cube
        block_side = fan_diameter + 2*box_border_width + game;
        block_height = fan_height + filter_height;
        
        shift = (block_side - box_side)/2;
        union(){
            translate([shift, shift, block_height + connection_box_height])
                union(){ 
                    difference(){
                        cube(size = [box_side,box_side,connection_box_height], center = false);
                        translate([box_border_width, box_border_width, 0])
                            cube(size = [box_side-2*box_border_width, box_side-2*box_border_width, connection_box_height], center = false);        
                    }

                    // add a stand for the top cube
                    translate([0,0, connection_box_height-(height_in_top_cubicle+box_border_width)]){        
                        difference(){
                            cube(size = [box_side, box_side, box_border_width], center = false);
                            
                            translate([2*box_border_width, 2*box_border_width, 0])
                                cube(size = [box_side-box_border_width*4, box_side-box_border_width*4, box_border_width],
                                     center = false);  
                        }
                    }
                }
            
            // 2) draw the connection shape
            translate([0, 0, block_height])
                difference(){
                    weird_cube([// bottom
                                [0,0,0],
                                [block_side,0,0],
                                [block_side,block_side,0],
                                [0,block_side,0],
                                // top
                                [shift, shift, connection_box_height],
                                [box_side+shift, shift, connection_box_height],
                                [box_side+shift, box_side+shift, connection_box_height],
                                [shift, box_side+shift, connection_box_height]]);
                    
                    translate([box_border_width/2, box_border_width/2, 0])
                        weird_cube([
                                    // bottom
                                    [0,0,0], 
                                    [block_side-box_border_width, 0,0], 
                                    [block_side-box_border_width, block_side-box_border_width, 0],
                                    [0, block_side - box_border_width, 0],
                                    
                                    // top
                                    [shift, shift, connection_box_height],
                                    [shift+box_side-box_border_width, shift, connection_box_height],
                                    [shift+box_side-box_border_width,shift+box_side-box_border_width, connection_box_height],
                                    [shift, shift+box_side-box_border_width, connection_box_height]]);
                }
                
            
            // 3) draw the main fan cube
            translate([0, 0, 0])
                difference(){
                    cube(size = [block_side, block_side, block_height], center = false);
                    translate([box_border_width, box_border_width, 0])
                        cube(size = [fan_diameter+game,
                                     fan_diameter+game,
                                     box_height], center = false);
                    //draw_holes(num_hole_layers, block_side);
                    // draw the wiring hole
                    translate([block_side, block_side-2*shift, filter_height + fan_height/2]) //block_height/2])
                        rotate([0,-90,0])
                                cylinder(h = box_border_width, r1 = wire_hole_diameter/2, r2 = wire_hole_diameter/2, center = false);
                }
                
            
                
            // 4) add logo
            add_logo(size=7, pos_x = block_side/2, pos_y=0, pos_z=block_height/2);
        }
        
        if(draw_legs == true){

            // 5) draw the leg cube
            in_top_box = 4;
            in_legs = 2;

            //translate([100, 0, leg_box_height-in_legs]) // when debugging
            translate([100, 0, leg_box_height]) // upside down
            rotate([180,0,0])
                union(){
                    difference(){
                        // connection square
                        translate([box_border_width+0.1*game, box_border_width+0.1*game, 0])
                            cube(size = [fan_diameter+0.8*game, fan_diameter+0.8*game, leg_box_height], center = false);
                        
                        translate([block_side/2, block_side/2, 0])
                            cylinder(h = leg_box_height, r1 = fan_diameter/2, r2 = fan_diameter/2, center = false);
                    }
                                            
                    // add legs, they will also act as support for the whole thingie
                    translate([0,0,-(leg_height-in_legs)])
                    union(){
                        translate([0, 0, 0])
                            cube(size = [leg_width,leg_width, leg_height], center = false);
                        
                        translate([block_side-leg_width, 0, 0])
                            cube(size = [leg_width, leg_width, leg_height], center = false);
                            
                        translate([block_side-leg_width, block_side-leg_width, 0])
                            cube(size = [leg_width, leg_width, leg_height], center = false);
                            
                        translate([0, block_side-leg_width, 0])
                            cube(size = [leg_width, leg_width, leg_height], center = false);
                    }
                }
        }
            
    }
}

module fan_support(add_motor_holder_floor = true){

    if(fan_type == "propeller"){
        // add support cylinder
        difference(){
            union(){   
                // add support to the support cylinder (arms)
                translate([0, (box_side/2)-box_border_width/2, fan_positioning]) cube([box_side, box_border_width, box_border_width], center = false);
                
                // add support to the support cylinder (arms)
                rotate(angle=90, [1, 0, 0]){
                    translate([0, (box_side/2)-box_border_width/2, fan_positioning])
                        cube([box_side, box_border_width, box_border_width], center = false);
                }
            
                // add support cylinder (rounded thingie)
                translate([(box_side/2), (box_side/2), fan_positioning]) cylinder(h = support_disk_height, r1 = motor_diameter/2 + support_disk_width, r2 = motor_diameter/2 + support_disk_width, center = false);
            }
            // remove motor size
            translate([(box_side/2), (box_side/2), fan_positioning])
                cylinder(h = support_disk_height, r1 = motor_diameter/2, r2 = motor_diameter/2, center = false);
        }
        
        if(add_motor_holder_floor){
            // add floor to motor holder
            difference(){
                translate([(box_side/2), (box_side/2), fan_positioning-motor_height/2])
                    cylinder(h = support_disk_height/2, r1 = motor_diameter/2 + support_disk_width, r2 = motor_diameter/2 + support_disk_width, center = false);
                
                translate([(box_side/2), (box_side/2), fan_positioning-motor_height/2])
                    cylinder(h = support_disk_height/2, r1 = motor_diameter/4, r2 = motor_diameter/2, center = false);
            }

            translate([(box_side/2)-(box_border_width + motor_diameter/2), (box_side/2)-(box_border_width/2), fan_positioning-motor_height/2])
                cube([box_border_width, box_border_width, motor_height/2], center = false);
            
            translate([(box_side/2)+(motor_diameter/2), (box_side/2)-(box_border_width/2), fan_positioning-motor_height/2])
                cube([box_border_width, box_border_width, motor_height/2], center = false);
        }
        
    }else{
        // flat fan type (noop)
        
    }
}

 module weird_cube(pps){ 
     polyhedron(
      points=pps,
      faces=[ [0,1,2,3], [3,2,6,7], [7,6,5,4], [4,0,3,7], [0,4,5,1], [1,5,6,2] ]
     );
 }

module show_fan(){
    if(fan_type == "propeller"){
        // show propeller as cone
        translate([(box_side/2), (box_side/2), fan_positioning+(motor_height/2)+fan_connection_height])
            color("grey")
                cylinder(h=fan_height, r1=fan_diameter/2, r2=fan_diameter/4, center=false);
    }else{
        // show common pc fan as cube-like
        translate([(box_side/2), (box_side/2), fan_positioning-fan_height/2])
            color("grey")
                cube([fan_diameter, fan_diameter, fan_height]);
    }
}

module show_motor(){
    if(fan_type == "propeller"){
        translate([(box_side/2), (box_side/2), fan_positioning-motor_height/2])
            color("grey")
                cylinder(h=motor_height, r1=motor_diameter/2, r2=motor_diameter/2, center=false);
    }else{
        // do nothing, the motor is integrated in the fan
    }
}

module random_stand(bs, bh, threshold = 10, seed, growing_only=true){ 
    min_threshold = threshold;
    if (growing_only) {
        min_threshold = 0;
    }
    
    random_vect = rands(bs-min_threshold, bs+threshold, 4, seed);
    
    weird_cube([[0,0,0], [random_vect[0],0,0], [random_vect[1],random_vect[2],0], [0,random_vect[3],0],      // bottom square (can be changed at wish)
                [0,0,bh], [bs,0,bh], [bs,bs,bh], [0,bs,bh]   // top square (has to match the existing cubicle)
    ]);
}

module add_logo(string = "pilillo", logo_depth= 1, strlen = 7, size=10,  pos_x, pos_y, pos_z){

    translate([pos_x, pos_y, pos_z])
        rotate([90, 0, 0])
            linear_extrude(height = logo_depth) {
                text(string, size = size, font = "Liberation Sans", halign = "center", valign = "center", $fn = 16);
            }
            //text(string, size = size, font = "Liberation Sans", halign = "center", valign = "center", $fn = 16);
}


cubicle(draw_legs = true);

//fan_support();
//show_motor();
//show_fan();

