
%%
close all
load MuaExample


x=MUA.coordinates(:,1) ;  y=MUA.coordinates(:,2) ;

[DxDx,DyDy,DxDy,DyDx]=DDxyMatrix(MUA);
M=MassMatrix2D1dof(MUA);


m=3;

%C=zeros(MUA.Nnodes,1)+1/20^m;
%sx=50e3 ; sy=50e3;
%C=exp(-((x+50e3).*(x+50e3)/sx^2+y.*y./sy^2))+exp(-((x-50e3).*(x-50e3)/(sx/2)^2+y.*y./(sy/2)^2));

C=1e6*sin(2*pi*x/100e3);


% Two ways of calculating J=0.5(  int (dfdx^2+dfdy^2) dx dy) / Area
[J,Jele,Area,EleArea]=GradNorm(MUA,C);
% and:
Jtest=C'*(DxDx+DyDy)*C/Area/2;

[J Jtest]

figure ; PlotMeshScalarVariable([],MUA,C); title('C')
figure ; PlotMeshScalarVariable([],MUA,Jele); title('|grad C| ele')
%figure ; PlotMeshScalarVariable([],MUA,EleArea);



dJ=(DxDx*C + DyDy*C)/Area;

figure ; PlotMeshScalarVariable([],MUA,dJ); title(' dJ ')



dJscaled=M\dJ;

figure ; PlotMeshScalarVariable([],MUA,dJscaled); title(' dJ scaled ')




%%


[dCdx,dCdy]=calcFEderivativesMUA(C,MUA);
[dCdx,dCdy]=ProjectFintOntoNodes(MUA,dCdx,dCdy);


figure ; QuiverColorGHG(x,y,dCdx,dCdy);




