function [UserVar,CtrlVar,MeshBoundaryCoordinates]=CreateMeshBoundaryCoordinatesForCrack(UserVar,CtrlVar)


a=UserVar.Crack.a; 
b=UserVar.Crack.b; 
x0=UserVar.Crack.x0; 
y0=UserVar.Crack.y0;



t=linspace(0,2*pi,250);  t(end)=[];
xe=x0+a*sin(t);
ye=y0+b*cos(t);



MeshBoundaryCoordinates=...
    [-UserVar.Domain -UserVar.Domain ; ...
    -UserVar.Domain UserVar.Domain ; ...
    UserVar.Domain UserVar.Domain ; ...
    UserVar.Domain -UserVar.Domain ; ...
    NaN  NaN ; ...
    xe(:) ye(:)] ;



end