
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

module symmetry(normal){
 children();
 mirror(normal) children();
}

module symm_x(){
 symmetry([1,0,0]) children();
}

module symm_y(){
 symmetry([0,1,0]) children();
}

module symm_z(){
 symmetry([0,0,1]) children();
}

//----------------------------------------
//geometric primitives
//----------------------------------------

//cube with centering only on given axis
module ccube(dim, center=[true,true,true]){
 center_tran=[center[0]?-dim[0]/2:0,center[1]?-dim[1]/2:0,center[2]?-dim[2]/2:0];
 translate(center_tran)
 cube(dim);
}

//truncated cone by small diameter and height
//negative height will make the tcone mirrored on xy
module tcone_dh(D,d,h){
 rotate_extrude()
  polygon([
   [0,0],
   [D/2,0],
   [d/2,h],
   [0,h]
  ]);
}

//truncated cone by small diameter and angle
//negative angle will make 
module tcone_da(D,d,a){
 tcone_dh(D,d,(D-d)/2*tan(a));
}

//truncated cone by height and angle
module tcone_ha(D,h,a){
 tcone_dh(D,D-2*h/tan(a),h);
}

//cone by height
module cone_h(D,h){
 tcone_dh(D,0,h);
}

//cone by angle
module cone_a(D,a){
 tcone_da(D,0,a);
}

//----------------------------------------
//useful parts
//----------------------------------------

//slot
module slot(pitch, d, h, center=false){
 hull(){
  tran_x(-pitch/2)
   cylinder(d=d,h=h,center=center);
  tran_x(pitch/2)
   cylinder(d=d,h=h,center=center);
 }
}

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
  tcone_da(head_d,d,head_angle);
 }
}

//screw by head height
module screw_h(d,l,head_h,head_angle=45){
 tran_z(-l)
  cylinder(d=d,h=l);
 tran_z(-head_h)
  tcone_ha(d,head_h,-head_angle);
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

//multiple children linear fit
//fits the maximum amount of children inside a given vector length and with a given spacing
//Parameters:
// dir - the vector direction for fit (fit will be done inside dir length)
// dist - distance between centers of children
// mode - 0 for odd fit, 1 for even fit, 2 for the maximum between the two
//NB:odd fit (mode 0) will alway place at least 1 children
module fit_children_linear(dir, spacing, mode){

 mod= norm(dir);
 dir_norm=dir/mod;

 //computing number of children
 oddnum =1 + 2*floor((mod/2)/(spacing)); //odd number
 evennum = 2*floor((mod/2+spacing/2)/(spacing)); //even number
 num = mode==0 ? oddnum : (mode == 1) ? evennum : max(oddnum, evennum);

 //starting position
 startpos = (num%2==1) ?
  mod/2 - spacing*(num-1)/2 : //odd
  (mod + spacing)/2 - num/2*spacing ; //even

 if(num>0)
  for(n = [0:1:num-1]){
   translate(dir_norm*(startpos+spacing*n))
    children();
  }
}