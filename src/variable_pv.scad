// Designed by Mihai Oltean
// https://mihaioltean.github.io
// license MIT
// PLEASE NOTE: I'm not a qualified person for designing solar systems!
// This is my home design. I offer no warranty or watsoever for it!
// Please ask a qualified person when designing such system!
// Bad design or execution can lead to injury or even death!

roof_angle = 18; // this is the angle for my home roof

SHOW_ROOF = 0; // 0=HIDE, 1=SHOW

num_solar_panels = 1; // on one row

//solar_panel_angle = 42; // UP; the highest I can go
//solar_panel_angle_complement = 21;

solar_panel_angle = 22; // MIDLLE
solar_panel_angle_complement = 11;

//solar_panel_angle = 1.6; // DOWN; the lowest I can go
//solar_panel_angle_complement = 2;

roof_tubes_radius = 12.5; // rectangular tubes of 20x20
roof_tubes_length = 4000;

// these values are for the Hyundai panels
solar_panel_size = [2056, 1140, 35]; 
solar_panel_distance_between_holes = [1234, 1090];

// position where the solar panels start on bar
solar_panel_start = 50;

solar_panel_transverse_size = [30, solar_panel_size[1] + 2 * solar_panel_start + 20, 40];

vertical_transverse_length = 920;
distance_between_roof_tubes = 1220;



solar_panel_distance_to_hole = [solar_panel_size[0] / 2 - solar_panel_distance_between_holes[0] / 2,
                                solar_panel_size[1] / 2 - solar_panel_distance_between_holes[1] / 2];

tolerance = 1;

cornier_length = 50; // for fixing panels to bars
cornier_size = 40;
cornier_thick = 3;

corner_panel_overlap = 12;

solar_panels_gap_horizontal = 100; // horizontal distance between panels
solar_panels_gap_vertical = 350; // horizontal distance between panels
//------------------------------------------------------------------------------------
module solar_panel_hyundai()
{
// solar panels by Hyundai
    color("silver") cube(solar_panel_size);
    translate([10, 10, solar_panel_size[2]]) 
        color("black") 
            cube([solar_panel_size[0], solar_panel_size[1], 2] - [20, 20, 0]);
    // ray
    // this is only to see the shadow of the panel
    translate([0, solar_panel_size[1], -2000]) color("red") cylinder(h = 2000, r = 3); 
    
}
//------------------------------------------------------------------------------------
module corner()
{
// corner for fixing the solar panel to bars
    difference(){
        color("red") cube([cornier_length, cornier_size, cornier_size]);
        translate([-tolerance, -tolerance, -tolerance]) cube([cornier_length + 2 * tolerance, cornier_size - cornier_thick + tolerance, cornier_size - cornier_thick + tolerance]);
        // screw hole
        translate([cornier_length / 2, corner_panel_overlap + 4, 0] - [0, 0, tolerance]) cylinder(r = 4, h = solar_panel_transverse_size[2] + 2 * tolerance);
    }
}
//------------------------------------------------------------------------------------
module transverse_base(length)
{
// bar on which the panels are placed or vertical bars
    difference(){
        cube([solar_panel_transverse_size[0], length, solar_panel_transverse_size[2]]);
        translate ([2, 0, 2] - [0, tolerance, 0]) cube(solar_panel_transverse_size-[4, 0, 4] + [0, 2*tolerance, 0]);
        // big hole for roof tube
        translate ([-tolerance, solar_panel_transverse_size[2] / 2, solar_panel_transverse_size[2] / 2]) rotate([0, 90, 0]) cylinder(h = solar_panel_transverse_size[0] + 2 * tolerance, r = 12.5);
        echo("base hole X =  ",solar_panel_transverse_size[2] / 2);
    }
}    
//------------------------------------------------------------------------------------
module transverse_for_solar_panel()
{
//bar on which the panels are placed
    difference(){
        transverse_base(solar_panel_transverse_size[1]);
        // hole for vertical connection
        translate ([-tolerance, solar_panel_transverse_size[1] - 20, solar_panel_transverse_size[2] / 2]) rotate([0, 90, 0]) cylinder(h = solar_panel_transverse_size[0] + 2 * tolerance, r = 4);
        echo("hole for vertical connection =  ", solar_panel_transverse_size[1] - 20);

        // holes for corners
        translate([solar_panel_transverse_size[0] / 2, solar_panel_start - 4, 0] - [0, 0, tolerance]) cylinder(r = 4, h = solar_panel_transverse_size[2] + 2 * tolerance);
        translate([solar_panel_transverse_size[0] / 2, solar_panel_start + solar_panel_size[1] + 4, 0] - [0, 0, tolerance]) cylinder(r = 4, h = solar_panel_transverse_size[2] + 2 * tolerance);
        echo("hole for corner 1 =  ", solar_panel_start - 4);
        echo("hole for corner 2 =  ", solar_panel_start + solar_panel_size[1] + 4);
        
        
        // holes for panel fixing
        translate([solar_panel_transverse_size[0] / 2, solar_panel_start +solar_panel_distance_to_hole[1], 0] - [0, 0, tolerance]) cylinder(r = 4, h = solar_panel_transverse_size[2] + 2 * tolerance);
        translate([solar_panel_transverse_size[0] / 2, solar_panel_start + solar_panel_size[1] - solar_panel_distance_to_hole[1], 0] - [0, 0, tolerance]) cylinder(r = 4, h = solar_panel_transverse_size[2] + 2 * tolerance);
        echo("hole 1 for panel =  ", solar_panel_start +solar_panel_distance_to_hole[1]);
        echo("hole 2 for panel =  ", solar_panel_start + solar_panel_size[1] - solar_panel_distance_to_hole[1]);
        
    }
}
//------------------------------------------------------------------------------------
module solar_panel_transverse_vertical()
{
// vertical bars used for setting the angle
    difference(){
        transverse_base(vertical_transverse_length);
        // hole for vertical connection
        
        for (i = [0:5])
            translate ([-tolerance, 55 + 165 * i, solar_panel_transverse_size[2] / 2]) rotate([0, 90, 0]) cylinder(h = solar_panel_transverse_size[0] + 2 * tolerance, r = 4);
        
        translate ([-tolerance, vertical_transverse_length - 20, solar_panel_transverse_size[2] / 2]) rotate([0, 90, 0]) cylinder(h = solar_panel_transverse_size[0] + 2 * tolerance, r = 4);
    }
}
//------------------------------------------------------------------------------------
module transverse_for_solar_panel_with_corners()
{
// combined bars with corners and screws

    transverse_for_solar_panel();
    // corner()
    translate ([-cornier_length / 2 + solar_panel_transverse_size[0] / 2, solar_panel_start - (cornier_size - corner_panel_overlap), solar_panel_transverse_size[2]] + [0, cornier_size, 0]) mirror([0, 1, 0]) corner();
    translate ([-cornier_length / 2 + solar_panel_transverse_size[0] / 2, solar_panel_start + solar_panel_size[1] - corner_panel_overlap, solar_panel_transverse_size[2]]) corner();

    // screws
        translate([solar_panel_transverse_size[0] / 2, solar_panel_start - 4, 0] - [0, 0, 5]) cylinder(r = 4, h = 90);
        translate([solar_panel_transverse_size[0] / 2, solar_panel_start + solar_panel_size[1] + 4, 0] - [0, 0, 5]) cylinder(r = 4, h = 90);    
}
//------------------------------------------------------------------------------------
module solar_panel_with_support()
{
// solar panel with bars, corners, screws
    translate ([0, solar_panel_start, solar_panel_transverse_size[2]]) solar_panel_hyundai();
    // first support
    translate ([-solar_panel_transverse_size[0] / 2 + solar_panel_size[0] / 2 - solar_panel_distance_between_holes[0] / 2, 0, 0]) transverse_for_solar_panel_with_corners();
    translate ([-solar_panel_transverse_size[0] / 2 + solar_panel_size[0] / 2 + solar_panel_distance_between_holes[0] / 2, 0, 0]) transverse_for_solar_panel_with_corners();
}
//------------------------------------------------------------------------------------
// MAIN
//------------------------------------------------------------------------------------
module one_row_of_solar_panels()
{
// roof support
    rotate([0, 90, 0]) color ("maroon") 
        cylinder(h = roof_tubes_length, r = roof_tubes_radius, $fn = 4);
    //rotate ([roof_angle, 0, 0]) 
        translate([0, distance_between_roof_tubes, 0]) rotate([0, 90, 0]) color ("maroon") cylinder(h = roof_tubes_length, r = roof_tubes_radius, $fn = 4);

// solar panels
    for (i = [0 : num_solar_panels - 1]){
        rotate([solar_panel_angle, 0, 0]) translate ([i * (solar_panel_size[0] + solar_panels_gap_horizontal), -solar_panel_transverse_size[2] / 2, -solar_panel_transverse_size[2] / 2]) solar_panel_with_support();
    // vertical tranverse
        translate ([i * (solar_panel_size[0] + solar_panels_gap_horizontal) + solar_panel_distance_to_hole[0] - 3/2 * solar_panel_transverse_size[0], distance_between_roof_tubes, 0
                //cos(roof_angle) *distance_between_roof_tubes, 
                //sin(roof_angle) *distance_between_roof_tubes
                ]) 
                rotate([90 + solar_panel_angle_complement, 0, 0]) 
                translate ([0, -solar_panel_transverse_size[2] / 2, 
                    -solar_panel_transverse_size[2] / 2]) 
                    solar_panel_transverse_vertical();
    // other side
        translate ([i * (solar_panel_size[0] + 100) + solar_panel_size[0] -         
                solar_panel_distance_to_hole[0] + 1/2*solar_panel_transverse_size[0], distance_between_roof_tubes, 0
      //          cos(roof_angle) *distance_between_roof_tubes, 
        //        sin(roof_angle) *distance_between_roof_tubes
        ]) 
                rotate([90 + solar_panel_angle_complement, 0, 0]) translate ([0, -solar_panel_transverse_size[2] / 2, -solar_panel_transverse_size[2] / 2]) solar_panel_transverse_vertical();
    }
}
//------------------------------------------------------------------------------------
module main()
{
    echo(solar_panel_transverse_size);
    rotate([roof_angle, 0, 0]){
        if (SHOW_ROOF == 1)
            cube([num_solar_panels * (solar_panel_size[0] + solar_panels_gap_horizontal), 3000, 1]);
        one_row_of_solar_panels();
        // second row; uncomment if needed
        //translate ([0, distance_between_roof_tubes + solar_panels_gap_vertical, 0]) one_row_of_solar_panels();
    }
}
//------------------------------------------------------------------------------------

main();

//solar_panel_transverse();
//solar_panel_hyundai();
//transverse_for_solar_panel();

//corner();
