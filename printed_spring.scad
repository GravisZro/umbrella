use <screwgen/circlestack_thread3.scad>
use <toothed_interlock.scad>


nil = $preview ? 0.001 : 0;
pole_radius = 6.25;
thickness = 2;


{
    height = 10;
    color("green")
        difference()
        {
            cylinder(h=height, r=pole_radius + thickness, center=false);
            translate([0,0,-nil])
                cylinder(h=height+ 2 * nil, r=pole_radius, center=false);
        }

    // top mounting teeth
    color("pink")        
        translate([0, 0, height - nil])
            toothed_interlock(inner_r = pole_radius, outer_r = pole_radius + thickness);
}
    
// bottom mounting teeth
rotate([0, 180, 0])
    color("purple")
        translate([0, 0, -nil])
            toothed_interlock(inner_r = pole_radius, outer_r = pole_radius + thickness);