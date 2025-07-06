use <screwgen/circlestack_thread3.scad>

preview_res = 48;
$fn = $preview ? preview_res : 128;

module rod_grasper(h, screw_r,
min_r, max_r, 
depth, profile, 
lead_in, 
split_count = 8, split = 0.15, nil = $preview ? 0.001 : 0)
{
    assert(is_num(h), "rod_grasper: argument 'h' (height) must be defined as a numeric value");
    assert(is_num(screw_r), "rod_grasper: argument 'screw_r' (screw radius) must be defined as a numeric value");
    assert(is_num(min_r), "rod_grasper: argument 'min_r' (minimum rod radius) must be defined as a numeric value");
    assert(is_num(max_r), "rod_grasper: argument 'max_r' (maximum rod radius) must be defined as a numeric value");
    assert(is_num(split_count), "rod_grasper: argument 'split_count' (number of splits in screw) must be a numeric value");
    assert(is_num(split), "rod_grasper: argument 'split' (maximum split distance in screw) must be a numeric value");
    assert(is_num(depth) || is_undef(depth), "rod_grasper: argument 'depth' (depth of screw) must be a numeric value");
    assert(is_num(profile) || is_undef(profile), "rod_grasper: argument 'profile' (profile of screw) must be a numeric value");
        
    screw_dia = screw_r * 2;

    thread_depth = is_undef(depth) ? ISO_thread_depth(dia = screw_dia, pitch = 0, angle = 30) : depth;
    thread_profile = is_undef(profile) ? sine_thread_profile($fn) : profile;

    degrees_per_segment = 360 / split_count;
    lead_in_height = is_undef(lead_in) ? h / 3 : lead_in;

    difference()
    {
        difference()
        {
            threaded_rod(thread_profile, thread_depth, length=h, dia=screw_dia, rshift=0, pitch=0, fn=$fn);
            translate([0, 0, lead_in_height])
                cylinder(h = h - lead_in_height + 2 * nil, r1 = max_r, r2 = min_r, center = false);
            translate([0, 0, -nil])
                cylinder(h = lead_in_height + 2 * nil, r = max_r, center = false);
        }

        for(angle = [0 : degrees_per_segment : 360 - degrees_per_segment])
            // angle = k * (360 / segcount), k=0 to (segcount - 1)
            rotate([90, 0, angle])
                linear_extrude(screw_r)
                    polygon([[-split, h + nil], [split, h + nil], [0, lead_in_height]]);
    }
}

rod_grasper(h = 8, screw_r = 2.5, min_r = 1.1, max_r = 1.6, split_count = 8);