function [UserVar,CtrlVar,MeshBoundaryCoordinates]=CreateMeshBoundaryCoordinatesForCrack(UserVar,CtrlVar)



a=0.1e3; % horizontal radius
b=5e3; % vertical radius
x0=0; % x0,y0 ellipse centre coordinates
y0=0;
t=linspace(-pi,pi,250);  t(end)=[];
xe=x0+a*cos(t);
ye=y0+b*sin(t);
CtrlVar.MeshSizeMax=1e3; 
CtrlVar.MeshSizeMin=0.1e3;
CtrlVar.GmshCharacteristicLengthFromCurvature = 1 ;
CtrlVar.GmshCharacteristicLengthExtendFromBoundary=1;


MeshBoundaryCoordinates=...
    [-10e3 -10e3 ; ...
    -10e3 10e3 ; ...
    10e3 10e3 ; ...
    10e3 -10e3 ; ...
    NaN  NaN ; ...
    xe(:) ye(:)] ;



end