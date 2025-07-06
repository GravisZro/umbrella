include <BOSL2/std.scad>
use <screwgen/circlestack_thread3.scad>

pole_diameter = 12.6;

support_diameter = 4;
support_length = 6;
support_sacrifice = support_diameter/5;

part_height = support_diameter;
part_radius = 20;

screw_diameter = 16;
screw_height = 12;

mount_height = 4;
mount_diameter = pole_diameter + 4;
mount_hole_diameter = 3;

$fn = $preview ? 20 : 256; // resolution of stacked polygons (number of sides)
$fnstep = 4; // pitch resolution is fn/fnstep per rotation

segment_count=8;
degrees_per_segment=360/segment_count;

difference()
{
    union()
    {

        difference()
        {
            linear_extrude(part_height)
                    octagon(r=part_radius, realign=true, rounding=2);


            for(angle = [0 : degrees_per_segment : 360])
            {
                rotate([0,0,angle])
                    translate([part_radius-support_diameter,0,part_height/2])
                                union()
                                {
                                        translate([-0.5,0,-support_sacrifice])
                                            rotate([90,90,0])
                                                cylinder(h=support_length, d=(part_height+support_diameter), center=true);
                                        translate([1,0,0])
                                            cube([support_diameter+2, support_length, part_height+2],center=true);
                                }
            }
        }
        
        difference()
        {
            union(){
                for(angle = [0 : degrees_per_segment : 360])
                    rotate([0,0,angle])
                        translate([part_radius - support_diameter, 0, part_height/2 - support_sacrifice])
                            rotate([90,90,0])
                                cylinder(h=10, d=support_diameter, center=true);
            }
            translate([0, 0, -part_height/2])
                cube([part_radius*2, part_radius*2, part_height], center=true);
        }
        

        // reenforcement
        for(angle = [0 : degrees_per_segment : 360])
            rotate([0,0,angle-degrees_per_segment/2])
                translate([part_radius/2 - 2,0,part_height/2])
                    cube([part_radius - support_diameter/2,5,part_height], center = true);

        translate([0, 0, part_height])
        {
            color("green")
                difference()
                {
                    // mounting base
                    linear_extrude(mount_height)
                        circle(d=mount_diameter);
                    // screw hole
                    translate([0, 0, mount_height/2])
                        rotate([90,0,0])
                                cylinder(h=pole_diameter, d=mount_hole_diameter, center=false);
                }
                
            color("blue")
                translate([0, 0, mount_height])
                {
                    pitch=0;
                    depth=ISO_thread_depth(screw_diameter,pitch,30);        
                    profile=sine_thread_profile($fn);
                    threaded_rod(profile, depth, length=screw_height, dia=screw_diameter, rshift=0, pitch=pitch, fn=$fn, fnstep=$fnstep);
                }
        }
    }
    
    translate([0,0, -50])        
        linear_extrude(100)
            circle(d=pole_diameter);
}
