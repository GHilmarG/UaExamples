function [VarOut,F]=MapVariableFromMidNodesToCornerNodesOfNod6Tri(F,connectivity,coordinates,VarIn)


CornerNodes=connectivity(:,1:2:6); CornerNodes=unique(CornerNodes);



if isempty(F)
    MidNodes=connectivity(:,2:2:6) ; MidNodes=unique(MidNodes);
    F = scatteredInterpolant(coordinates(MidNodes,1),coordinates(MidNodes,2),VarIn(MidNodes)) ;
end
VarOut=VarIn;
VarOut(CornerNodes) = F(coordinates(CornerNodes,1),coordinates(CornerNodes,2)) ;

end