use <arm_cannon.scad>;
include <config.scad>;

module InnerSectionAssembly(config, col="red")
{
  translate([0, 0, config[1]-(material_thickness/2)])
  {
    color(col)
    {
      linear_extrude(height=material_thickness)
      {
        if(config[0] == "cutout")
          InnerSection(config[2]);
        if(config[0] == "aperture")
          InnerApertureSection();
      }
    }
  }
}

for(i = sections)
{
  translate([0, 0, i[0]*section_length])
  {
    RotateAroundHex(width, linear_offset=material_thickness)
    {
      rotate([90, 0, 0])
      {
        color("blue")
        {
          linear_extrude(height=material_thickness)
          {
            if(i[1] == "solid")
              SidePanel();
            if(i[1] == "cutout")
              SidePanel()
                SidePanelCutouts();
          }
        }

        if(i[1] == "cutout")
        {
          translate([0, (section_length/4), material_thickness])
            color("cyan", 0.5)
              linear_extrude(height=material_thickness)
                SidePanelInsert();
          translate([0, (section_length*3/4), material_thickness])
            color("cyan", 0.5)
              linear_extrude(height=material_thickness)
                SidePanelInsert();
        }
      }
    }
  }
}

for(j = inner_braces)
  InnerSectionAssembly(j);

through_bolt_length = (2 * through_bolt_assembly_offset) + (inner_braces[len(inner_braces)-1][1] - inner_braces[0][1]);
echo(str("Bolt Length: ", through_bolt_length, "mm"));

translate([0, 0, inner_braces[0][1]-through_bolt_assembly_offset])
  RotateAroundHex(0, linear_offset=through_bolt_hole_radius, angle_offset=30, step=2)
    color("silver")
      cylinder(d=through_bolt_diameter, h=through_bolt_length);

translate([0, 0, inner_braces[len(inner_braces)-1][1] + material_thickness/2])
{
  translate([0, 0, (aperture_front_length/2)])
  RotateAroundHex(0, linear_offset=(aperture_mount_diameter+material_thickness)/2)
    rotate([90, 0, 0])
      color("orange")
        linear_extrude(height=material_thickness)
          AperturePanel();

  translate([0, 0, aperture_front_length])
    color("green")
      linear_extrude(height=material_thickness)
        FrontApertureSection();
}

translate([0, 0, 800])
  color("orange")
    linear_extrude(height=material_thickness)
      InnerLaserMount();
