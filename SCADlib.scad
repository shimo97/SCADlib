//torus
module torus(D,d,angle=360){
 rotate_extrude(angle)
  translate([D/2,0,0])
   circle(r=d/2);
}

//screw by head diameter
module screw_d(d,l,head_d,head_angle=45){
 mirror([0,0,1]){
  cylinder(d=d,h=l);
 
  rotate_extrude()
   polygon([
    [0,0],
    [head_d/2,0],
    [d/2,((head_d-d)/2)*tan(head_angle)],
    [0,((head_d-d)/2)*tan(head_angle)]
   ]);
 }
}

//screw by head height
module screw_h(d,l,head_h,head_angle=45){
 mirror([0,0,1]){
  cylinder(d=d,h=l);
 
  rotate_extrude()
   polygon([
    [0,0],
    [head_h/tan(head_angle)+d/2,0],
    [d/2,head_h],
    [0,head_h]
   ]);
 }
}
}