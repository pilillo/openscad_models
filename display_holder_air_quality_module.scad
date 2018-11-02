$fn = 100;

include <external_modules/threads.scad>;

inner_display_width       = 71;
inner_display_height      = 24;

outer_display_width       = 80;
outer_display_height      = 36;
outer_display_thickness   = 45;

box_border_thickness    = 1;
display_game            = 0.5;
box_cap_thickness       = 10;

box_size_width          = outer_display_width + display_game + box_border_thickness*2;
box_size_height         = outer_display_height + display_game + box_border_thickness*2;
box_size_depth          = outer_display_thickness + display_game + box_border_thickness*2;

display_screw_diameter  = 2.8;
display_screw_offset    = 1;

support_height          = outer_display_thickness;

mcu_height = 26;
mcu_width = 49;
mcu_depth = 10;

usb_conn_shift = 10.2;
usb_conn_width = 7.2;
usb_conn_height = 3;

bus_width = 20;
bus_height = 5;


module display_holder(support=true, screw_support=false){
    union(){
        difference(){
            // draw the box
            cube([box_size_width,
                  box_size_height,
                  box_size_depth],
                  center = false);
        
            // remove from the box the size of the box
            translate([box_border_thickness, box_border_thickness, box_border_thickness])
                cube([box_size_width -2*box_border_thickness,
                      box_size_height -2*box_border_thickness,
                      outer_display_thickness+display_game+box_border_thickness
                      //outer_display_thickness-box_border_thickness*2
                    ], center = false);
     
            // draw the display
            shift_x = (box_size_width - inner_display_width) / 2;
            shift_y = (box_size_height - inner_display_height) / 2;
            translate([shift_x, shift_y, 0])
                cube([inner_display_width + display_game, inner_display_height + display_game, box_border_thickness], center = false);
            
            // bus opening for wiring
            union(){
                h = 28;
                b = 3;
                translate([0, bus_width/2, box_size_depth-h])
                    /*
                    cube([bus_height,
                        bus_width,
                        box_border_thickness*4],
                        center = false);
                        */
                    cube([box_border_thickness*4,
                        b,
                        h],
                        center = false);
            }
        }
        

        // draw the cylinders to hold the display
        if(support == true){
            // draw support 1 (0, 0)
            screw_shift = box_border_thickness+display_game + display_screw_offset;
            translate([ screw_shift,
                        screw_shift,
                        box_border_thickness])
                support(support_border_size=0.5, screw_support=screw_support);
            
            // draw support 2 (x1, 0)
            translate([ box_size_width - screw_shift,
                        screw_shift,
                        box_border_thickness])
                support(support_border_size=0.5, screw_support=screw_support);
            
            // draw support 3 (0, y1)
            translate([ screw_shift,
                        box_size_height - screw_shift,
                        box_border_thickness])
                support(support_border_size=0.5, screw_support=screw_support);
                         
            // draw support 4 (x1, y1)
            translate([ box_size_width - screw_shift,
                        box_size_height - screw_shift,
                        box_border_thickness])
                support(support_border_size=0.5, screw_support=screw_support);
        }
    }
    
}



module support(support_border_size=0.5, screw_support=true){
    o_d = (display_screw_diameter-display_game*2);
    i_d = ((display_screw_diameter-display_game*2)-support_border_size);

    ch = box_border_thickness;
    if(screw_support == true){
        ch = support_height;
    }
    
    difference(){        
        cylinder(h = ch,
                 r1 = (display_screw_diameter-display_game)/2,
                 r2 = o_d/2,
                 center = false);

        translate([ 0,
                    0,
                    support_border_size])
            cylinder(h = ch,
                    r1 = ((display_screw_diameter-display_game)-support_border_size)/2,
                    r2 = i_d/2,
                    center = false);
        
    }
    if(screw_support == true){
        // draw nuts to put screws for the tap
        translate([ 0, 0, ch+support_border_size])
            nut(d=o_d, l= 10, t_game=0.1);
    }
}


module tap(support_border_size=0.5){
    // draw the box tap
    inner_width          = outer_display_width + display_game;
    inner_height         = outer_display_height + display_game;
    
    union(){
    
        difference(){
            union(){
                // outer cube
                cube([box_size_width,
                      box_size_height,
                      box_cap_thickness/2],
                    center = false);
                
                // inner cube
                translate([box_border_thickness, box_border_thickness,0])
                    cube([  inner_width,
                            inner_height,
                            box_cap_thickness],
                        center = false);
            }
            
            // empty cube inside
            translate([box_border_thickness*2, box_border_thickness*2, box_border_thickness])
                cube([inner_width - box_border_thickness*2,
                      inner_height - box_border_thickness*2,
                      box_cap_thickness],
                    center = false);

        }
    
        // support for MCU
        mcu_p_d = 2.8;
        mcu_p_shift = 1.2;

        shift_mcu_w = (box_size_width - mcu_width) / 2;
        shift_mcu_h = (box_size_height - mcu_height) / 2;
              

        translate([ shift_mcu_w-support_border_size, shift_mcu_h-support_border_size, box_border_thickness])
        union(){
            // mark the size of the mcu using a box
            //translate([0, 0, 0])
            difference(){
                cube([mcu_width+2*support_border_size,
                      mcu_height+2*support_border_size,
                      support_border_size]);

                translate([support_border_size, support_border_size, 0])
                    cube([mcu_width, mcu_height, support_border_size]);
            }
            
            translate([support_border_size, support_border_size, 0]){
                // ray of the support
                r = mcu_p_d/2;
                // we need to translate by r as the cylinder is by default centered
                // support 1
                translate([ r+mcu_p_shift, 
                            r+mcu_p_shift,
                            0])
                    cylinder(h = mcu_depth,
                            r1 = r,
                            r2 = r,
                            center = false);
                // support 2
                translate([ r+mcu_p_shift, 
                            mcu_height - (r+mcu_p_shift),
                            0])
                    cylinder(h = mcu_depth,
                            r1 = r,
                            r2 = r,
                            center = false);
                // support 3
                translate([ mcu_width - (r+mcu_p_shift),
                            r+mcu_p_shift,
                            0])
                    cylinder(h = mcu_depth,
                            r1 = r,
                            r2 = r,
                            center = false);
                // support 4
                translate([ mcu_width - (r+mcu_p_shift),
                            mcu_height - (r+mcu_p_shift),
                            0])
                    cylinder(h = mcu_depth,
                            r1 = r,
                            r2 = r,
                            center = false);
             }
        }
    
    }
}

display_holder();

translate([0, 50, 0]) tap();




// Modules to print nuts and screws

module nut(d=10, l=5, t_game=0.1){
    difference(){
        cylinder(h=l-0.2, r1=(d/2)+t_game, r2=(d/2)+t_game, center=false);
        metric_thread(diameter=d, pitch=1, length=2*l, internal=true);
    }
}

module screw(cap_height=2.5, cap_d=10, d=8, l=5, t_game=0.1){
    translate([0, 0, l])
        cylinder(h = cap_height, r1 = cap_d/2, r2 = cap_d/2, center = false);
    metric_thread(diameter=d, pitch=1, length=l, internal=false);
}

module upside_down_screw(cap_height=2.5, cap_d=10, d=8, l=5, t_game=0.1){
    translate([0,0,l+cap_height])
        rotate([180, 0, 0])
            screw(cap_height=cap_height, cap_d=cap_d, d=d, l=l, t_game=t_game);
}


// testing screw and nut
//upside_down_screw();
//translate([0,20,0]) nut();