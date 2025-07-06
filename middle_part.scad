include <BOSL2/std.scad>


pole_diameter=12.6;


support_diameter=4;
support_length=6;
support_sacrifice=support_diameter/5;

part_height=support_diameter;
part_radius=20;

$fn=200;///10;

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
        for(angle = [0 : degrees_per_segment : 360])
        {
            rotate([0,0,angle])
                translate([part_radius-support_diameter,0,part_height/2])
                    difference()
                    {
                        union()
                        {
                                translate([-0.5,0,-support_sacrifice])
                                    rotate([90,90,0])
                                        cylinder(h=support_length, d=(part_height+support_diameter), center=true);
                                translate([1,0,0])
                                    cube([support_diameter+2, support_length, part_height+2],center=true);
                        }
                        
                        rotate([90,90,0])
                            translate([support_sacrifice,0,0])
                                cylinder(h=10, d=support_diameter, center=true);
                    }
        }
    }
}