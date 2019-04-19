Point(1) = {0.000000,0.000000,0.000000,0.100000};
Point(2) = {0.000000,0.500000,0.000000,0.100000};
Point(3) = {0.000000,1.000000,0.000000,0.100000};
Point(4) = {1.000000,1.000000,0.000000,0.100000};
Point(5) = {1.000000,0.000000,0.000000,0.100000};
Point(6) = {-1.000000,0.000000,0.000000,0.100000};
Point(7) = {-1.000000,0.500000,0.000000,0.100000};
Line(1)={1,2};
Line(2)={2,3};
Line(3)={3,4};
Line(4)={4,5};
Line(5)={5,1};
Line(6)={1,6};
Line(7)={6,7};
Line(8)={7,2};
Line Loop(1)={1,2,3,4,5};
Line Loop(2)={6,7,8,-1};
Plane Surface(1)={1};
Plane Surface(2)={2};
Mesh.Algorithm = 1 ; 
Mesh.CharacteristicLengthMin = 0.100000 ; 
Mesh.CharacteristicLengthMax = 0.100000 ; 
Mesh.CharacteristicLengthExtendFromBoundary = 0 ; 
Mesh.CharacteristicLengthFromCurvature = 0 ; 
     
 