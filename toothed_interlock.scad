// top mounting teeth
module toothed_interlock(inner_r, outer_r, tooth_count = 16, depth = 1.5, nil = $preview ? 0.001 : 0)
{
    tooth_inner_len = (inner_r * PI *2) / tooth_count;
    tooth_outer_len = ((outer_r) * PI *2) / tooth_count;
    tooth_thickness = outer_r - inner_r + 2;
    degrees_per_tooth = 360 / tooth_count;
    
    difference()
    {
        difference()
        {
            cylinder(h=depth, r=outer_r, center=false);
            translate([0,0,-nil])
                cylinder(h=depth + 2 * nil, r=inner_r, center=false);
        }
        translate([0, 0, depth+nil])
            for(angle = [0 : degrees_per_tooth : 360 - degrees_per_tooth])
                rotate([0,0,angle])
                    translate([0, inner_r - 1, 0])
                        rotate([90,180-90,180])
                             hull()
                            {
                                linear_extrude(1)
                                    polygon([[0,-tooth_inner_len/2],[depth,0],[0,tooth_inner_len/2]]);
                                
                                translate([0,0, tooth_thickness + 1])
                                    linear_extrude(1)
                                        polygon([[0,-tooth_outer_len/2],[depth,0],[0,tooth_outer_len/2]]);
                            }
    }
}