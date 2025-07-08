use <screwgen/circlestack_thread3.scad>
use <rod_grasper.scad>

preview_res = 48;
$fn = $preview ? preview_res : 48;
nil = $preview ? 0.001 : 0;

screw_radius = 4;
lead_in = ISO_hex_nut_hi(screw_radius * 2);
screw_height = lead_in * 2.5;

thread_depth = is_undef(depth) ? ISO_thread_depth(dia = screw_radius * 2, pitch = 0, angle = 30) : thread_depth;
thread_profile = is_undef(profile) ? sine_thread_profile($fn) : thread_profile;

grasp_min_radius = 1.1;
grasp_max_radius = 1.6;

base_height = 2;
base_radius = screw_radius + 0.75;

difference()
{
    cylinder(h = base_height, r = base_radius);
    translate([0, 0, -nil])
        cylinder(h = base_height + 2 * nil, r = grasp_max_radius, center = false);
}

translate([0, 0, 2])
    rod_grasper(h = screw_height, screw_r = screw_radius, min_r = grasp_min_radius, max_r = grasp_max_radius, thread_depth = thread_depth, thread_profile = thread_profile);
