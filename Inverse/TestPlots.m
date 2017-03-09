load TestSave



P=NodalFormFunctionInfluence(MUA);


figure ; PlotNodalBasedQuantities(MUA.connectivity,MUA.coordinates,P,CtrlVar) ;

%%
con3=MUA.connectivity(:,1:2:6); nod3=unique(con3);
figure ; plot3(MUA.coordinates(nod3,1),MUA.coordinates(nod3,2),P(nod3),'.') ; title('P corner nodes')

conMid=MUA.connectivity(:,2:2:6) ; nodMid=unique(conMid);
figure ; plot3(MUA.coordinates(nodMid,1),MUA.coordinates(nodMid,2),P(nodMid),'.') ; title('P midnodes')

%%
figure ; plot3(MUA.coordinates(nod3,1),MUA.coordinates(nod3,2),dIdC(nod3),'.') ; title('dIdC corner nodes')
figure ; plot3(MUA.coordinates(nodMid,1),MUA.coordinates(nodMid,2),dIdC(nodMid),'.') ; title('dIdC midnodes')


%%
figure ; plot3(MUA.coordinates(nod3,1),MUA.coordinates(nod3,2),dIdC(nod3)./P(nod3),'.') ; title('dIdC scaled corner nodes')
figure ; plot3(MUA.coordinates(nodMid,1),MUA.coordinates(nodMid,2),dIdC(nodMid)./P(nodMid),'.') ; title('dIdC scaled midnodes')


%%
F=[];
dIdCscaled=dIdC./P;
[dIdCscaled2,F]=MapVariableFromMidNodesToCornerNodesOfNod6Tri(F,MUA.connectivity,MUA.coordinates,dIdCscaled);


figure ; plot3(MUA.coordinates(:,1),MUA.coordinates(:,2),dIdCscaled2,'.') ; title('dIdCscaled2')