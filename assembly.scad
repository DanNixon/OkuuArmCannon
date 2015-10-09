use <arm_cannon.scad>;
include <config.scad>;

for(i = inner_brace_positions)
  translate([0, 0, i])
    linear_extrude(height=material_thickness)
      InnerSection(arm);

offset = (width / 2) * sin(60);
translate([0, 0, length/2])
  for(i = [0:5])
    rotate([0, 0, (60*i)+30])
      translate([offset, 0, 0])
        rotate([90, 0, 90])
          linear_extrude(height=material_thickness)
            SidePanel(300);
