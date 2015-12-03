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

module RotateAroundHex(width, linear_offset=0, angle_offset=0, axis="x", step=1)
{
  d = ((width / 2) * sin(60)) + linear_offset;
  for(i = [0:step:5])
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
      circle(d=hole_diameter);

    RotateAroundHex(0, linear_offset=through_bolt_hole_radius, angle_offset=30, step=2)
      circle(d=through_bolt_diameter);
    RotateAroundHex(0, linear_offset=through_bolt_hole_radius, angle_offset=90, step=2)
      circle(d=mount_bolt_hole_radius);

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

      children();
		}
  }
}

module SidePanelCutouts()
{
  m = 5;

  translate([0, (section_length/4)])
  {
    minkowski()
    {
      square([side_cutout_x-m, side_cutout_y-m], center=true);
      circle(r=m);
    }
    SidePanelCutoutMountingHoles();
  }

  translate([0, -(section_length/4)])
  {
    minkowski()
    {
      square([side_cutout_x-m, side_cutout_y-m], center=true);
      circle(r=m);
    }
    SidePanelCutoutMountingHoles();
  }
}

module SidePanelInsert(d = 15)
{
  x = side_cutout_x + d;
  y = side_cutout_y + d;

  difference()
  {
    square([x, y], center=true);
    SidePanelCutoutMountingHoles();
  }
}

module SidePanelCutoutMountingHoles(d=5)
{
  x_diff = (side_cutout_x / 2) + d;
  y_diff = (side_cutout_y / 2) + d;

  translate([x_diff, 0])
  {
    translate([0, y_diff])
      circle(r=screw_hole_radius);
    translate([0, -y_diff])
      circle(r=screw_hole_radius);
  }
  translate([-x_diff, 0])
  {
    translate([0, y_diff])
      circle(r=screw_hole_radius);
    translate([0, -y_diff])
      circle(r=screw_hole_radius);
  }
}

module InnerMount()
{
  difference()
  {
    hull()
    {
      RotateAroundHex(0, linear_offset=through_bolt_hole_radius, angle_offset=90, step=2)
        circle(d=15);
    }

    RotateAroundHex(0, linear_offset=through_bolt_hole_radius, angle_offset=90, step=2)
      circle(d=mount_bolt_hole_radius);

    children();
  }
}

module InnerLaserMount()
{
  InnerMount()
  {
    // Red laser
    rotate([0, 0, 60])
    {
      translate([laser_offset, 0, 0])
      {
        circle(d=laser_diameter_red);
        translate([10, 0, 0])
          text("RED", valign="center", size=5);
      }
    }

    // Green laser
    rotate([0, 0, 180])
    {
      translate([laser_offset, 0, 0])
      {
        circle(d=laser_diameter_green);
        translate([10, 0, 0])
          text("GREEN", valign="center", size=5);
      }
    }

    // Blue laser
    rotate([0, 0, 300])
    {
      translate([laser_offset, 0, 0])
      {
        circle(d=laser_diameter_blue);
        translate([10, 0, 0])
          text("BLUE", valign="center", size=5);
      }
    }
  }
}

module InnerElectronicsMount()
{
  InnerMount()
  {
    translate([0, 15])
      square([material_thickness + material_tolerance, 10 + material_tolerance], center=true);
    translate([0, -15])
      square([material_thickness + material_tolerance, 10 + material_tolerance], center=true);
  }
}
