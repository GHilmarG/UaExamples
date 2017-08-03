Point(1) = {0.000000,0.000000,0.000000,10000.000000};
Point(2) = {0.000000,80000.000000,0.000000,10000.000000};
Point(3) = {640000.000000,80000.000000,0.000000,10000.000000};
Point(4) = {640000.000000,0.000000,0.000000,10000.000000};
Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};
Line Loop(1) = {1:4};
Plane Surface(1) = {1};
Mesh.Algorithm = 8 ; 
Mesh.CharacteristicLengthMin = 100.000000 ; 
Mesh.CharacteristicLengthMax = 10000.000000 ; 
Mesh.CharacteristicLengthExtendFromBoundary = 0 ; 
Mesh.CharacteristicLengthFromCurvature = 0 ; 
     
 