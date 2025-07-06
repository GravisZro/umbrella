//include <BOSL2/std.scad>
use <screwgen/circlestack_thread3.scad>

pole_radius = 6.25;


support_radius = 1.5;
support_length = 6;

base_height = support_radius * 2;
base_radius = 15.5 - support_radius;

screw_radius = 17/2;
screw_height = 12;

thread_depth=ISO_thread_depth(dia=screw_radius*2, pitch=0, angle=30);

mount_height = 4;
mount_radius = screw_radius - thread_depth/2;;
mount_base_radius = mount_radius + 1;

mount_hole_radius = 1.5;
mount_hole_diameter = mount_hole_radius * 2;
mount_transition_height=2;

preview_res = 48;
$fn = $preview ? preview_res : 128; // resolution of stacked polygons (number of sides)

segment_count = 8;
degrees_per_segment=360 / segment_count;
side_length=5;


difference()
{
    union()
    {
        // mount base outer ring
        for(angle = [0 : degrees_per_segment : 360 - degrees_per_segment]) // angle = k*45, k=0 to 7
        {
            // mount base outer ring joints
            color("orange")
                rotate([0,0,angle])
                    translate([base_radius - support_radius, 0, base_height / 2])
                        rotate([90,90,0])
                            cylinder(h=side_length, r=support_radius, center=true);
            
            // mount base outer ring joint connector
            color("yellow")
                hull()
                {
                    // left side of joint
                    rotate([90,0,angle])
                        translate([base_radius - support_radius, base_height/2, side_length/2])
                            cylinder(h=0.00001, r=support_radius, center=true); // infinitely thin
                    // right side of previous joint
                    rotate([90,0,angle-degrees_per_segment])
                        translate([base_radius - support_radius, base_height/2, -side_length/2])
                            cylinder(h=0.00001, r=support_radius, center=true); // infinitely thin
                    // mount base outer ring connector to mount base inner ring
                    rotate([0,0,angle - degrees_per_segment/2])
                        translate([base_radius/2 - 2, 0, base_height/2])
                            cube([base_radius, 4, base_height], center = true);
                    }
        }

        // mount base inner ring
        color("red")
            cylinder(h=base_height, r=mount_base_radius);

        translate([0, 0, base_height])
        {
            // mount base inner ring to mount transition
            color("white")
                cylinder(h=2, r1=mount_base_radius, r2=mount_radius);

            // mount
            color("green")
                translate([0, 0, mount_transition_height])
                    linear_extrude(mount_height)
                        circle(r=mount_radius);

            // screw
            color("blue")
                translate([0, 0, mount_height + mount_transition_height])
                {
                    
                    profile=sine_thread_profile($fn);
                    threaded_rod(profile, thread_depth, length=screw_height, dia=screw_radius*2, rshift=0, pitch=0, fn=$fn);
                }
        }
    }
    
    // geometry to be subtracted
    union()
    {
        // mount geometry for mounting holes
        translate([0, 0, base_height + mount_transition_height])
            rotate([0,0,degrees_per_segment / 2])
                translate([0, 0, mount_height / 2])
                {
                    // opposing side of mount hole
                    rotate([-90,0,0])
                            cylinder(h=mount_radius, r=mount_hole_radius*3/4, center=false);

                    // side with mounting hole
                    rotate([90,0,0])
                    {
                        // mount hole
                        cylinder(h=mount_radius, r=mount_hole_radius, center=false);
                        // mount hole relief
                        translate([0, 0, mount_radius - mount_hole_radius / 2])
                            cylinder(h=1, r1=mount_hole_radius, r2=mount_hole_radius * 1.5, center=false);
                    }
                }

        // pole hole
        cylinder(h=50, r=pole_radius, center=true);
    }
}
