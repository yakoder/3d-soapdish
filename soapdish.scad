hasDripEdge = 1;
hasFrontWall = 0;
hasGrooves = 1;

wallThickness = 2.4;
grooveThickness = 2 * wallThickness;
// back of groove, front will be wallThickness more than this
grooveDepth = 2 * wallThickness;
floorThickness = 2 * grooveDepth; // allow for slight angle inside grooves
dripEdgeHeight = 45;
dripEdgeThickness = floorThickness;

totalWidth = (110 / 2) + 82 - 7;
totalDepth = 132 - 21.4 - 7 + (hasDripEdge * dripEdgeThickness);
frontHeight = 0;
backHeight = 38;
totalHeight = backHeight;

innerWidth = totalWidth - (2 * wallThickness);
innerDepth = totalDepth - wallThickness - (hasFrontWall * wallThickness);
innerHeight = totalHeight - floorThickness;
dispAdjust = 0.1; // adjustment to add to wall removals to clean up display

// 1 - 1 = 0 * dispAdjust = 0 (no adjustment for keeping wall)
// 1 - 0 = 1 * dispAdjust = dispAdjust (add adjustment for removing wall)
adj = (1 - hasFrontWall) * dispAdjust;

sideAngle = atan((backHeight - frontHeight - floorThickness) / innerDepth);
grooveAngle = atan(grooveDepth / (innerDepth - wallThickness));

// grooves and ridges
numberGrooves = floor((innerWidth - grooveThickness) / grooveThickness);
echo("numberGrooves",numberGrooves);
groovesOffset = (totalWidth - (grooveThickness * numberGrooves)) / 2;
echo("groovesOffset",groovesOffset);
//FIXME: 'numberGrooves' really should be this math, but can't get it working, as it is off by some amount
//numberGrooves2 = floor(innerWidth / (2 * wallThickness));
//echo("numberGrooves2",numberGrooves2);
//groovesOffset2 = (totalWidth - (wallThickness * 2 * numberGrooves2) + wallThickness) / 2;
//echo("groovesOffset2",groovesOffset2);

// soap dish
difference() {
    // cube for main soap box
    translate([-(totalWidth / 2), -(totalDepth / 2), 0])
    cube([totalWidth, totalDepth, totalHeight]);

    // cutout for inner opening
    translate([-((totalWidth / 2) - wallThickness),
               -((totalDepth / 2) - (hasFrontWall * wallThickness) + adj),
               floorThickness])
    cube([innerWidth, innerDepth + adj, innerHeight + dispAdjust]);

    // side walls
    translate([-(totalWidth / 2) - dispAdjust,
               -(totalDepth / 2) - dispAdjust,
               floorThickness])
    rotate([sideAngle, 0, 0])
    cube([totalWidth + (2 * dispAdjust),
          sqrt(innerDepth ^ 2 + innerHeight ^ 2),
          totalHeight - floorThickness]);
    
    // grooves
    for(groove = [0 : 2 : (numberGrooves)]) {
        rotate([grooveAngle, 0, 0])
        translate([-(totalWidth / 2)
                        + groovesOffset
                        + (groove * grooveThickness),
                   -((totalDepth / 2) - sqrt(dispAdjust/2)),
                   (floorThickness - grooveDepth) - dispAdjust])
        cube([grooveThickness,
              sqrt((totalDepth - grooveThickness) ^ 2
                    + grooveThickness ^ 2)
                + dispAdjust,
              floorThickness]);
    }

    // front drainage holes
    if (! hasFrontWall) {
        for(groove = [0 : 2 : (numberGrooves)]) {
            translate([-(totalWidth / 2)
                            + groovesOffset
                            + (groove * grooveThickness),
                       -((totalDepth / 2) + dispAdjust),
                       -dispAdjust])
            cube([grooveThickness,
                  grooveDepth + dispAdjust,
                  floorThickness + (2 * dispAdjust)]);
        }
    }
}

// drip edge
if (hasDripEdge) {
    difference() {
        // cube for main drip edge
        translate([-(totalWidth / 2),
                   -(totalDepth / 2),
                   -dripEdgeHeight])
        cube([totalWidth, dripEdgeThickness, dripEdgeHeight]);
        
        // grooves
    //    for(groove = [0 : 2 : (numberGrooves2 * 2)]) {
        for(groove = [0 : 2 : (numberGrooves)]) {
            translate([-(totalWidth / 2)
                            + groovesOffset
                            + (groove * grooveThickness),
                       -((totalDepth / 2) + dispAdjust),
                       -(dripEdgeHeight + dispAdjust)])
            cube([grooveThickness,
                  grooveDepth + dispAdjust,
                  dripEdgeHeight + (2 * dispAdjust)]);
        }
    }
}