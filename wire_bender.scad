preview_res = 48;
$fn = $preview ? preview_res : 128; // resolution of stacked polygons (number of sides)

wire_diameter=1;
support_radius = 1.5;
bender_height=2;
bender_wall_thickness=3;
radius_over_margin=0.1;
nil = $preview ? 0.01 : 0;

cylinder(h=bender_height, r=support_radius + radius_over_margin, center=false);

module arc(h, outer, inner, degrees, center=false)
{
    degrees = degrees % 360;
    mult = outer*2;
    nil = $preview ? 0.01 : 0;
    difference()
    {
        difference()
        {   
            cylinder(h=h, r=outer, center=center);
        
            translate([0,0,-nil])
                linear_extrude(h+2*nil)
                {
                    rotate([0,0, 90 * floor(degrees/90)])
                    difference()
                    {
                        square([outer, outer]);
                        polygon([[mult, 0], [0,0], [cos(degrees%90) * mult, sin(degrees%90) * mult]]);
                    }
                    if(degrees < 90)
                        translate([-outer,0,0])
                            square([outer, outer]);
                    
                    if(degrees < 180)
                        translate([-outer,-outer,0])
                            square([outer, outer]);
                    
                    if(degrees < 270)
                        translate([0,-outer,0])
                            square([outer, outer]);
                }                
        }
        translate([0,0,-nil])
            cylinder(h=h+2*nil, r=inner, center=center);
    }
}

rotate([0, 0, $t * 360])
{
    inner = support_radius + radius_over_margin  + wire_diameter;
    outer = inner + bender_wall_thickness;
    arc(h=bender_height, outer=outer, inner=inner, degrees=130, center=false);
}