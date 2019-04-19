

function [MeshBoundaryCoordinates,CtrlVar]=CreateMeshBoundaryCoordinatesForBrunt(CtrlVar)

%%


% Bedmap2
%
% CurDir=pwd;
% cd(getenv('AntarcticGlobalDataSets'))
% load Bedmap2/ZeroIceThicknessContour.mat
% cd(CurDir)

load 2015-12-BruntCalvingFront.mat

%if ~CtrlVar.BSC
%    tt=[-7.02e+05  -6.4314e+05   1.4651e+06   1.505e+06];
%    I=BCF.x > tt(1) & BCF.x < tt(2) & BCF.y > tt(3) & BCF.y< tt(4) ;
%    BCF.x(I)=[]; BCF.y(I)=[];
%    %figure ; plot(BCF.x,BCF.y,'r.-') ; axis equal
%end


xh0=BCF.x ; yh0=BCF.y;

CtrlVar.GLtension=1e-9; % tension of spline, 1: no smoothing; 0: straight line
CtrlVar.GLds=CtrlVar.MeshSizeBoundary;

[x,y,nx,ny] = Smooth2dPos(xh0,yh0,CtrlVar);


load AddionalPoints xp yp


ymin=min(yp) ; ymax=max(yp);
I=(y>ymax | y <ymin) ;  y(I)=[] ; x(I)=[];
I=x>0 | x < -1e6;  y(I)=[] ; x(I)=[];
x=x(:) ; y=y(:);
x=[flipud(xp) ; x] ; y=[flipud(yp) ; y];

MeshBoundaryCoordinates=[x(:) y(:)];


fprintf('Loading %s \n',CtrlVar.Chasm1File)
load(CtrlVar.Chasm1File);
MeshBoundaryCoordinates=[1 NaN ; MeshBoundaryCoordinates; 1 NaN ; Chasm1.XY];

%% Gmsh format 2

%clear all ; close all
%load BruntMeshBoundaryCoordinates.mat

I=find(isnan(MeshBoundaryCoordinates(:,1)) | isnan(MeshBoundaryCoordinates(:,2)));

i1a=I(1)+1 ; i1b=I(2)-1;  
i2a=I(2)+1 ; i2b=size(MeshBoundaryCoordinates,1);





CtrlVar.Gmsh.Points=[MeshBoundaryCoordinates(i1a:i1b,:); MeshBoundaryCoordinates(i2a:i2b,:) ];
l1a=1 ; l1b=l1a+i1b-i1a;
l2a=l1b+1 ; l2b=l2a+i2b-i2a;
CtrlVar.Gmsh.Lines{1}=[(l1a:l1b)';l1a];
CtrlVar.Gmsh.Lines{2}=[(l2a:l2b)';l2a];



Box=[-7.02e+05  -6.4314e+05   1.4651e+06   1.505e+06];
I=CtrlVar.Gmsh.Points(:,1) > Box(1) & CtrlVar.Gmsh.Points(:,1) < Box(2) ...
    & CtrlVar.Gmsh.Points(:,2) > Box(3) & CtrlVar.Gmsh.Points(:,2) < Box(4) ;


% now must line 1 into two lines, with one convering the BIS-SW chasm outlines only

x=CtrlVar.Gmsh.Points(CtrlVar.Gmsh.Lines{1},1);
y=CtrlVar.Gmsh.Points(CtrlVar.Gmsh.Lines{1},2);
K=x > Box(1) & x < Box(2) ...
    & y > Box(3) & y < Box(4) ;

temp=CtrlVar.Gmsh.Lines{1};
temp(K)=NaN; temp(end)=[];
J=find(isnan(temp));
tt=[temp(J(end)+1:end,end);temp(1:J(1)-1)];
CtrlVar.Gmsh.Lines{3}=tt;
CtrlVar.Gmsh.Lines{4}=find(K);
CtrlVar.Gmsh.Lines{4}=[CtrlVar.Gmsh.Lines{3}(end); CtrlVar.Gmsh.Lines{4};CtrlVar.Gmsh.Lines{3}(1)];

CtrlVar.Gmsh.Lines{5}=[CtrlVar.Gmsh.Lines{3}(end);CtrlVar.Gmsh.Lines{3}(1)];
CtrlVar.Gmsh.Lines{6}=[CtrlVar.Gmsh.Lines{4}(end);CtrlVar.Gmsh.Lines{4}(1)];

% figure 
% plot(CtrlVar.Gmsh.Points(CtrlVar.Gmsh.Lines{1},1),CtrlVar.Gmsh.Points(CtrlVar.Gmsh.Lines{1},2),'.-')
% hold on
% plot(CtrlVar.Gmsh.Points(CtrlVar.Gmsh.Lines{2},1),CtrlVar.Gmsh.Points(CtrlVar.Gmsh.Lines{2},2),'^-')
% plot(CtrlVar.Gmsh.Points(CtrlVar.Gmsh.Lines{3},1),CtrlVar.Gmsh.Points(CtrlVar.Gmsh.Lines{3},2),'+-')
% hold on
% plot(CtrlVar.Gmsh.Points(CtrlVar.Gmsh.Lines{4},1),CtrlVar.Gmsh.Points(CtrlVar.Gmsh.Lines{4},2),'O-')
% plot(CtrlVar.Gmsh.Points(CtrlVar.Gmsh.Lines{5},1),CtrlVar.Gmsh.Points(CtrlVar.Gmsh.Lines{5},2),'*-')
% legend('1','2','3','4','5')


CtrlVar.Gmsh.Loops{1}=[3,4];
CtrlVar.Gmsh.Loops{2}=[2];
CtrlVar.Gmsh.Loops{3}=[-4,5];

CtrlVar.Gmsh.PlaneSurfaces{1} = [1,-2];
CtrlVar.Gmsh.PlaneSurfaces{2} = [2];
CtrlVar.Gmsh.PlaneSurfaces{3} = [3];


%MUA=genmesh2d(CtrlVar,MeshBoundaryCoordinates); 
%figure ;  PlotFEmesh(MUA.coordinates,MUA.connectivity)
%hold on ; PlotGmshGeometryDefinition(CtrlVar)



%CtrlVar.GmshPlaneSurface{1}=[1 2];
%CtrlVar.GmshPlaneSurface{2}=[2];

%save('MeshBoundaryCoordinates','MeshBoundaryCoordinates')

%figure ; plot(MeshBoundaryCoordinates(:,1),MeshBoundaryCoordinates(:,2),'r.-')


end