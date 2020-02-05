function [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)
    
    
    as=zeros(MUA.Nnodes,1)+0.3;
    ab=zeros(MUA.Nnodes,1);

    if time>= 0.1 && contains(UserVar.RunType,"-HighMelt-")
        
        GF=IceSheetIceShelves(CtrlVar,MUA,GF);
        CutOff=400e3;
        I=GF.NodesDownstreamOfGroundingLines & MUA.coordinates(:,1) > CutOff ;
        ab(I)=-100;
        
    end
    
end

