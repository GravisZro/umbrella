use <screwgen/circlestack_thread3.scad>

preview_res = 48;
$fn = $preview ? preview_res : 48;
nil = $preview ? 0.001 : 0;

screw_radius = 4;
lead_in = ISO_hex_nut_hi(screw_radius * 2);
screw_height = lead_in * 2.5;

thread_depth = is_undef(depth) ? ISO_thread_depth(dia = screw_radius * 2, pitch = 0, angle = 30) : thread_depth;
thread_profile = is_undef(profile) ? sine_thread_profile($fn) : thread_profile;

hex_nut(dia=screw_radius * 2, pitch=0, rshift=0.1, fn=$fn, fnstep=4, thread_depth = thread_depth, thread_profile = thread_profile);