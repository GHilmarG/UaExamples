

load TestSAve
xGL=[] ; yGL=[] ; GLgeo=[] ;
%%
aTol=1000; 
nTol=15e3;

x=MUA.coordinates(:,1) ; y=MUA.coordinates(:,2);
CtrlVar.PlotGLs=0;
 [xGL,yGL,GLgeo]=PlotGroundingLines(CtrlVar,MUA,GF,GLgeo,xGL,yGL);


xGL=[xGL(1:10);NaN;xGL(21:end)];
yGL=[yGL(1:10);NaN;yGL(21:end)];

[Ind,AlongDist,NormDist] = DistanceToLineSegment([x y], [xGL yGL], [],nTol,aTol);


figure ; PlotMuaMesh(CtrlVar,MUA)
hold on 
plot(xGL/1000,yGL/1000,'r','LineWidth',2);

plot(x(Ind)/1000,y(Ind)/1000,'or')


