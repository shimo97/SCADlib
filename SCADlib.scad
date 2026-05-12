
//----------------------------------------
//simple utilities
//----------------------------------------
module tran_x(dx=0){
 translate([dx,0,0]) children();
}

module tran_y(dy=0){
 translate([0,dy,0]) children();
}

module tran_z(dz=0){
 translate([0,0,dz]) children();
}

module rot_x(ax=0){
 rotate([ax,0,0]) children();
}

module rot_y(ay=0){
 rotate([0,ay,0]) children();
}

module rot_z(az=0){
 rotate([0,0,az]) children();
}

//----------------------------------------
//useful parts
//----------------------------------------

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

//----------------------------------------
//multi-children generation modules
//----------------------------------------

//multiple children linear pattern generator
//Parameters:
// n - number of children
// dist - distance between children
// dir - direction vector of the linear array
// center - flag to center the array
module multi_children_linear(n,dist,dir=[1,0,0],center=false){

 //computing translation vector
 dir_vect=dist*dir/norm(dir);
 //computing centering vector
 center_vect= center ? -dir_vect*(n-1)/2 : [0,0,0];
 
 translate(center_vect)
  for(i=[0:1:n-1]){
   translate(i*dir_vect)
    children();
  }
}