include <config.scad>;

module InnerSection(hole_diameter=0)
{
  difference()
  {
    hull()
    {
      for(i = [0:5])
        rotate([0, 0, 60*i])
          translate([width/2, 0, 0])
            circle(r=0.01);
    }

    if(hole_diameter > 0)
      circle(r=hole_diameter/2);
  }

  offset = (width / 2) * sin(60) + (material_thickness / 2);
  for(i = [0:5])
  {
    rotate([0, 0, 60*i])
    {
      translate([0, offset, 0])
      {
        translate([assembly_tab_offset/2, 0, 0])
          square([assembly_tab_width, material_thickness], center=true);
        translate([-assembly_tab_offset/2, 0, 0])
          square([assembly_tab_width, material_thickness], center=true);
      }
    }
  }
}

module SidePanel()
{
  translate([0, 0, -material_thickness/2])
  {
    square([width/2, length], center=true);
  }
}
