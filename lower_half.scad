include <BOSL2/std.scad>


pole_diameter=12.5;
part_height=7;
part_radius=17;
divit_depth=5;
divit_width=5;
divit_half_width=divit_width/2;
screw_depth=4;
screw_diameter=3;
screw_radius = screw_diameter/2;
$fn=200;




screw_raidus_from_center = part_radius - screw_diameter-1;

segment_count=8;
degrees_per_segment=360/segment_count;

difference()
{    
    linear_extrude(part_height){
        difference()
        {
            octagon(r=part_radius, realign=true, rounding=2);
            circle(d=pole_diameter);
        }
    }

    union()
    {
        for(angle = [0 : 45 : 360])
        {
            rotate([0,0,angle])
                translate([-divit_half_width,part_radius-divit_depth-4,part_height-divit_depth+0.1])
                    rotate([90,0,90])
                        linear_extrude(divit_width)
                            union(){
                                translate([divit_depth/2,divit_depth/2,0])
                                    circle(d=divit_depth);
                                translate([0,divit_depth/2,0])
                                    square([divit_depth, divit_depth/2]);
                            }

                rotate([0,0,angle - degrees_per_segment/2])
                    translate([screw_raidus_from_center,0,part_height-screw_depth+0.1])
                        linear_extrude(screw_depth)
                            circle(d=screw_diameter);
        }
    }
}