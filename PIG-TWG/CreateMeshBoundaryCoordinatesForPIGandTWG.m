
function MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(CtrlVar)

load PigBoundaryCoordinates MeshBoundaryCoordinates
MeshBoundaryCoordinates=flipud(MeshBoundaryCoordinates);
I=MeshBoundaryCoordinates(:,2)>-973818.250320996-1;
MeshBoundaryCoordinates=[MeshBoundaryCoordinates(I,1) MeshBoundaryCoordinates(I,2)];


end