
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined,F)

% Defines model geometry

x=MUA.coordinates(:,1); y=MUA.coordinates(:,2);
alpha=0.;
B=MismBed(x,y);
S=B*0;
s=[];
b=[];


if contains(FieldsToBeDefined,"b") ||  contains(FieldsToBeDefined,"s")
    s=F.s ;
    b=F.b ;
    if contains(UserVar.RunType,"-ManuallyModifyThickness-")
        
        if ~isempty(F.GF)
            if CtrlVar.CurrentRunStepNumber==2
                
                F.GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);
                CutOff=400e3;
                I=F.GF.NodesDownstreamOfGroundingLines & x> CutOff ;
                hMin=CtrlVar.ThickMin+1 ;
                s(I)=b(I)+hMin;
                
            end
            
        end
    end
end


% initial def for s and b at start of run
if CtrlVar.CurrentRunStepNumber<=1
    b=B;
    h0=1000-1000/640e3*x;
    s=b+h0;
end

end
