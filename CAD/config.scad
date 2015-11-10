material_thickness = 3;
material_tolerance = 0.1;
screw_hole_radius = 1.6;

arm = 100;

aperture_diameter = 40;
aperture_front_diameter = 65;
aperture_front_length = 30;
aperture_tab_offset = 15;
aperture_tab_width = 5;
aperture_mount_diameter = 50;

width = 150;
section_length = 300;

sections = [
  [0, "solid"],
  [1, "cutout"],
  [2, "cutout"]
];

number_sections = 3;

assembly_tab_offset = 40;
assembly_tab_width = 10;

through_bolt_diameter = 6;
through_bolt_hole_radius = 60;
through_bolt_assembly_offset = 5;
mount_bolt_hole_radius = 3;

inner_braces = [
  ["cutout", 10,  arm],
  ["cutout", 150, arm],
  ["cutout", 290, arm],
  ["cutout", 310, arm],
  ["cutout", 450, arm],
  ["cutout", 590, arm],
  ["cutout", 610, arm],
  ["cutout", 750, arm],
  ["aperture", 890]
];

side_cutout_x = 40;
side_cutout_y = 100;
