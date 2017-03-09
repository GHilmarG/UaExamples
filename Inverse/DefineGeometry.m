
function [UserVar,s,b,S,B,alpha]=DefineGeometry(UserVar,CtrlVar,MUA,time,FieldsToBeDefined)

switch lower(UserVar.RunType)
    
    case 'icestream'
        
        hmean=1000;
        b=zeros(MUA.Nnodes,1) ;
        S=zeros(MUA.Nnodes,1)-1e10;
        B=b ;
        s=hmean+b;
        
        alpha=0.01 ;
        
    case 'iceshelf'
        
        hmean=1000;
        b=zeros(MUA.Nnodes,1) ;
        S=zeros(MUA.Nnodes,1);
        B=S*0-1e10;
        s=hmean+b;
        
        alpha=0 ;
        
end


end

