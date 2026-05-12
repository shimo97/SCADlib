//torus
module torus(D,d,angle=360){
 rotate_extrude(angle)
  translate([D/2,0,0])
   circle(r=d/2);
}