//$fn = 100;

border_height       = 5;
border_width        = 7;
sphere_size         = 4;
game                = 0.25;

inner_radius        = 10;
outer_radius        = 20;
border_shift        = border_height / 2;
inner_sphere_shift  = border_shift + (inner_radius + outer_radius) / 2;

ball_number         = 12;

// draw the frame
rotate_extrude(){
    difference(){
        union(){
            translate([inner_radius+border_shift, 0])
                square([border_height, border_width], center=true);
            translate([outer_radius+border_shift, 0])
                square([border_height, border_width], center=true);
        }
    translate([inner_sphere_shift, 0, 0]) circle(sphere_size);
    }
}

// draw the inner balls
for(ball_center = [0:360/ball_number:360]){
    rotate([0,0, ball_center])
        translate([inner_sphere_shift, 0, 0])
            sphere(sphere_size-game);
}
