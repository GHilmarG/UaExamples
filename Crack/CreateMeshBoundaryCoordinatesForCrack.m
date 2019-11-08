function [UserVar,CtrlVar,MeshBoundaryCoordinates]=CreateMeshBoundaryCoordinatesForCrack(UserVar,CtrlVar)


a=UserVar.Crack.a; 
b=UserVar.Crack.b; 
x0=UserVar.Crack.x0; 
y0=UserVar.Crack.y0;



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