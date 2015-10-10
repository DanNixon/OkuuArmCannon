use <arm_cannon.scad>;
include <config.scad>;

module InnerSectionAssembly(position, c="red")
{
  translate([0, 0, position-(material_thickness/2)])
    color(c)
      linear_extrude(height=material_thickness)
        children();
}

InnerSectionAssembly(inner_brace_positions[0])
  InnerSection(arm);

InnerSectionAssembly(inner_brace_positions[1])
  InnerSection(arm);

InnerSectionAssembly(inner_brace_positions[2])
  InnerApertureSection();

InnerSectionAssembly(inner_brace_positions[2] + aperture_front_length + material_thickness/2, "green")
  FrontApertureSection();

translate([0, 0, inner_brace_positions[2] + aperture_front_length/2])
  RotateAroundHex(0, linear_offset=(aperture_mount_diameter+material_thickness)/2)
    rotate([90, 0, 0])
      linear_extrude(height=material_thickness)
        AperturePanel();

RotateAroundHex(width, linear_offset=material_thickness)
  rotate([90, 0, 0])
    color("blue")
      linear_extrude(height=material_thickness)
        SidePanel();
