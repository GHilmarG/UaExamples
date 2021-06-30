
function MeshBoundaryCoordinates=CreateMeshBoundaryCoordinatesForPIGandTWG(UserVar,CtrlVar)


%% 

% load boundary based on BedMachine data
load(UserVar.MeshBoundaryCoordinatesFile,"Boundary") ; 

% Now smooth and sub-sample Boundary
CtrlVar.GLtension=1e-10; % tension of spline, 1: no smoothing; 0: straight line
CtrlVar.GLds=UserVar.DistanceBetweenPointsAlongBoundary;

[xB,yB] = Smooth2dPos(Boundary(:,1),Boundary(:,2),CtrlVar);



% Corner Points defining the interior points of the computational domain
% CP=flipud([ ...
% -1500000.                  -970000.           ; ...
% -1347067.05618705          -970000.            ; ...
% -1026436.41400166          -657218.66446336 ; ...
% -845400.065012632          -441283.742175242 ; ...
% -703624.61098508           -151189.351626557 ; ...
% -1080965.43478149            58202.0881679823 ; ...
% -1277269.90958887            16760.0323753131 ; ...
% -1377603.30782375            21122.3540376993 ; ...
% -1427770.00694119           160716.647234059 ; ...
% -1785480.38325687           160716.647234059  ...
% ]) ; 
% writematrix(CP,'DomainCornerPoints.csv')
CP=readmatrix('DomainCornerPoints.csv'); 

 % get rid of global boundary points outside of local computational domain
yMax=max(CP(:,2)) ; yMin=min(CP(:,2)) ; 
xMax=max(CP(:,1)) ; xMin=min(CP(:,1)) ; 
I=yB>yMax |  yB<yMin | xB > xMax ; 
xB=xB(~I) ; yB=yB(~I) ; 

% replace start and end points of outer boundary with start and end points corner points
xB(1) = CP(end,1) ;  yB(1) = CP(end,2) ;  
xB(end) = CP(1,1) ;  yB(end) = CP(1,2) ;  
% and then get rid of those start and end corner nods
CP(1,:)=[] ; CP(end,:)=[] ; 

MeshBoundaryCoordinates=[CP;xB yB] ;

% FindOrCreateFigure("MeshBoundaryCoordinates") 
%  plot(MeshBoundaryCoordinates(:,1)/1000,MeshBoundaryCoordinates(:,2)/1000,'r.-')
%  axis equal


end