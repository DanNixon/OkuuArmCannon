use <CAD-Library/panel_nut_fixing.scad>;
include <config.scad>;

module Hexagon(w)
{
  hull()
  {
    for(i = [0:5])
      rotate([0, 0, 60*i])
        translate([w/2, 0, 0])
          circle(r=0.01);
  }
}

module RotateAroundHex(width, linear_offset=0, angle_offset=0, axis="x")
{
  d = ((width / 2) * sin(60)) + linear_offset;
  for(i = [0:5])
    rotate([0, 0, (60 * i) + angle_offset])
      translate([0, d, 0])
        children();
}

module InnerSection(hole_diameter=0)
{
	offset = (width / 2) * sin(60) + (material_thickness / 2);

  difference()
  {
    Hexagon(width);

    if(hole_diameter > 0)
      circle(r=hole_diameter/2);

    RotateAroundHex(width, linear_offset=0.01)
      rotate([0, 0, 180])
        PanelNutFixing_M3();
  }

  RotateAroundHex(width, linear_offset=(material_thickness/2)-0.01)
  {
    translate([assembly_tab_offset/2, 0, 0])
      square([assembly_tab_width, material_thickness+0.01], center=true);
    translate([-assembly_tab_offset/2, 0, 0])
      square([assembly_tab_width, material_thickness+0.01], center=true);
  }
}

module InnerApertureSection()
{
  ApertureMounts()
    InnerSection(aperture_diameter);
}

module FrontApertureSection()
{
  ApertureMounts()
  {
    difference()
    {
      Hexagon(aperture_front_diameter);
      circle(r=aperture_diameter/2);
    }
  }
}

module ApertureMounts()
{
  difference()
  {
    children();

    RotateAroundHex(0, linear_offset=(aperture_mount_diameter)/2)
    {
      circle(r=screw_hole_radius);
      translate([aperture_tab_offset/2, 0, 0])
        square([aperture_tab_width+material_tolerance, material_thickness+material_tolerance], center=true);
      translate([-aperture_tab_offset/2, 0, 0])
        square([aperture_tab_width+material_tolerance, material_thickness+material_tolerance], center=true);
    }
  }
}

module AperturePanel()
{
  offset = (aperture_front_length / 2) - 0.01;

  difference()
  {
    square([(aperture_mount_diameter+material_thickness)/2, aperture_front_length], center=true);

    translate([0, -offset-0.02, 0])
      PanelNutFixing_M3();
    translate([0, offset+0.02, 0])
      rotate([180, 0, 0])
        PanelNutFixing_M3();
  }

  tab_offset = offset + (material_thickness / 2);

  translate([aperture_tab_offset/2, tab_offset, 0])
    square([aperture_tab_width, material_thickness], center=true);
  translate([-aperture_tab_offset/2, tab_offset, 0])
    square([aperture_tab_width, material_thickness], center=true);

  translate([aperture_tab_offset/2, -tab_offset, 0])
    square([aperture_tab_width, material_thickness], center=true);
  translate([-aperture_tab_offset/2, -tab_offset, 0])
    square([aperture_tab_width, material_thickness], center=true);

}

module SidePanel()
{
  translate([0, section_length/2, -material_thickness/2])
  {
		difference()
		{
			square([width/2, section_length], center=true);

			for(i = inner_braces)
			{
				translate([0, i[1]-(section_length/2), 0])
				{
					circle(r=screw_hole_radius);
					translate([assembly_tab_offset/2, 0, 0])
						square([assembly_tab_width+material_tolerance, material_thickness+material_tolerance], center=true);
					translate([-assembly_tab_offset/2, 0, 0])
						square([assembly_tab_width+material_tolerance, material_thickness+material_tolerance], center=true);
				}
			}
		}
  }
}
