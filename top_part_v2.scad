//include <BOSL2/std.scad>
use <screwgen/circlestack_thread3.scad>

pole_diameter = 12.6;
//pole_diameter = 12.8;



support_radius = 2;
support_length = 6;

base_height = support_radius * 2;
base_radius = 20 - support_radius;

screw_diameter = 17;
screw_height = 12;

thread_depth=ISO_thread_depth(dia=screw_diameter, pitch=0, angle=30);

mount_height = 5;
mount_diameter = screw_diameter - thread_depth/4;
mount_hole_radius = 1.5;
mount_hole_diameter = mount_hole_radius * 2;

preview_res = 48;
$fn = $preview ? preview_res : 128; // resolution of stacked polygons (number of sides)

segment_count = 8;
degrees_per_segment=360 / segment_count;

difference()
{
    union()
    {

        difference()
        {
            // base
            color("yellow")
                hull()
                {
                    for(angle = [0 : degrees_per_segment : 360])
                        rotate([0,0,angle])
                            translate([base_radius - support_radius, 0, base_height/2])
                                rotate([90,90,0])
                                    cylinder(h=7, r=support_radius, center=true);
                }

            // subtracted part from base
            for(angle = [0 : degrees_per_segment : 360])
            {
                rotate([0,0,angle])
                    translate([base_radius-support_radius*2, 0, base_height/2])
                    {
                        rotate([90,90,0])
                            cylinder(h=support_length, d=(base_height + support_radius * 2), center=true);
                        translate([1,0,0])
                            cube([support_radius * 2 + 2, support_length, base_height + 2],center=true);
                     }
            }
        }
        
        // outer ring
        color("orange")
            for(angle = [0 : degrees_per_segment : 360])
                rotate([0,0,angle])
                    translate([base_radius - support_radius, 0, base_height/2])
                        rotate([90,90,0])
                            cylinder(h=7, r=support_radius, center=true);

        // reenforcement
        color("pink")
            for(angle = [0 : degrees_per_segment : 360])
                rotate([0,0,angle - degrees_per_segment/2])
                    translate([base_radius/2 - 2, 0, base_height/2])
                        cube([base_radius - support_radius, 4, base_height], center = true);

        translate([0, 0, base_height])
        {
            // mount column
            color("green")
                difference()
                {
                    // mounting base
                    linear_extrude(mount_height)
                        circle(d=mount_diameter);
                    // screw hole
                    translate([0, 0, mount_height/2+mount_hole_radius/3])
                    {
                        rotate([-90,0,0])
                                cylinder(h=pole_diameter, r=mount_hole_radius, center=false);
                        rotate([90,0,0])
                                cylinder(h=pole_diameter, r=mount_hole_radius*3/4, center=false);
                        translate([0, pole_diameter-mount_hole_diameter-0.25, mount_hole_radius/64])
                            sphere(r=mount_hole_radius*1.5);
                    }
                }
                
             // screw
            color("blue")
                translate([0, 0, mount_height])
                {
                    
                    profile=sine_thread_profile($fn);
                    threaded_rod(profile, thread_depth, length=screw_height, dia=screw_diameter, rshift=0, pitch=0, fn=$fn);
                }
        }
    }
    
    translate([0,0, -50])        
        linear_extrude(100)
            circle(d=pole_diameter);
}
