use <screwgen/circlestack_thread3.scad>


pole_diameter = 12.6;

screw_diameter = 16;
screw_height = 12;

color("blue")
{
    fn=256;    // resolution of stacked polygons (number of sides)
    fnstep=4; // pitch resolution is fn/fnstep per rotation
    pitch=0;
    depth=ISO_thread_depth(screw_diameter,pitch,30);        
    profile=sine_thread_profile(fn);
    threaded_rod(profile, depth, length=screw_height, dia=screw_diameter, rshift=0, pitch=pitch, fn=fn, fnstep=fnstep);
}