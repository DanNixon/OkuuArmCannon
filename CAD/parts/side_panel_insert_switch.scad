use <../arm_cannon.scad>;
include <../config.scad>;

switch_hole_diam = 12;
fuse_hole_diam = 12;

difference()
{
  SidePanelInsert();

  translate([-2, 0])
  {
    // Switch
    translate([0, 15])
    {
      circle(d=switch_hole_diam, center=true);
      translate([15, 0])
        rotate([0, 0, -90])
          text("MASTER", valign="center", halign="center", size=5);
    }

    // Fuse
    translate([0, -30])
    {
      circle(d=fuse_hole_diam, center=true);
      translate([15, 0])
        rotate([0, 0, -90])
          text("FUSE 5A FAST", valign="center", halign="center", size=3);
    }
  }
}
