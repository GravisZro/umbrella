use <screwgen/circlestack_thread3.scad>

preview_res = 48;
$fn = $preview ? preview_res : 128;

module rod_grasper(h, screw_r,
min_r, max_r,
thread_depth, thread_profile,
lead_in,
split_count = 8, split = 0.5, nil = $preview ? 0.001 : 0)
{
    assert(is_num(h), "rod_grasper: argument 'h' (height) must be defined as a numeric value");
    assert(is_num(screw_r), "rod_grasper: argument 'screw_r' (screw radius) must be defined as a numeric value");
    assert(is_num(min_r), "rod_grasper: argument 'min_r' (minimum rod radius) must be defined as a numeric value");
    assert(is_num(max_r), "rod_grasper: argument 'max_r' (maximum rod radius) must be defined as a numeric value");
    assert(is_num(split_count), "rod_grasper: argument 'split_count' (number of splits in screw) must be a numeric value");
    assert(is_num(split), "rod_grasper: argument 'split' (maximum split distance in screw) must be a numeric value");
    assert(is_num(thread_depth) || is_undef(thread_depth), "rod_grasper: argument 'thread_depth' (depth of thread) must be a numeric value");
    assert(is_list(thread_profile) || is_undef(thread_profile), "rod_grasper: argument 'thread_profile' (profile of thread) must be a list value");
        
    screw_dia = screw_r * 2;

    thread_depth = is_undef(depth) ? ISO_thread_depth(dia = screw_dia, pitch = 0, angle = 30) : thread_depth;
    thread_profile = is_undef(profile) ? sine_thread_profile($fn) : thread_profile;

    degrees_per_segment = 360 / split_count;
    lead_in_height = is_undef(lead_in) ? ISO_hex_nut_hi(screw_r * 2) : lead_in;

    difference()
    {
        difference()
        {
            threaded_rod(thread_profile, thread_depth, length=h, dia=screw_dia, rshift=0, pitch=0, fn=$fn);
            union()
            {
                translate([0, 0, lead_in_height])
                    cylinder(h = h - lead_in_height + 2, r1 = max_r, r2 = min_r, center = false);
                cylinder(h = lead_in_height, r = max_r, center = false);
            }
        }

        for(angle = [0 : degrees_per_segment : 360 - degrees_per_segment])
            // angle = k * (360 / segcount), k=0 to (segcount - 1)
            rotate([90, 0, angle])
                linear_extrude(screw_r)
                    polygon([[-split, h + 1], [split, h + 1], [0, lead_in_height]]);
    }
}
/*
screw_radius = 2.5;
lead_in = ISO_hex_nut_hi(screw_radius * 2);
screw_height = lead_in * 2.5;
thread_depth = ISO_thread_depth(dia = screw_radius * 2, pitch = 0, angle = 30);
thread_profile = sine_thread_profile($fn);
grasp_min_radius = 1.1;
grasp_max_radius = 1.6;

rod_grasper(h = screw_height, screw_r = screw_radius, min_r = grasp_min_radius, max_r = grasp_max_radius, thread_depth = thread_depth, thread_profile = thread_profile, lead_in = lead_in);
*/
