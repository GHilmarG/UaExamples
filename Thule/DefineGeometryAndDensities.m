




function  [UserVar,s,b,S,B,rho,rhow,g]=DefineGeometryAndDensities(UserVar,CtrlVar,MUA,F,FieldsToBeDefined)


persistent Fs Fb


g=9.81/1000;
rho=917   ;
rhow=1030 ;





B=Bedgeometry(UserVar,CtrlVar,MUA,F,BedName=UserVar.Region);
S=zeros(MUA.Nnodes,1);

s=[] ; b=[] ;

if contains(FieldsToBeDefined,"-s-") || contains(FieldsToBeDefined,"-b-")

    if contains(UserVar.RunType,"-SSmin-")
        s=10; b=0;
    elseif contains(UserVar.RunType,"-SSmax-")
        r=sqrt(F.x.*F.x+F.y.*F.y) ;
        B0=2000 ; % B(0,0) for Thule
        h0=2000;
        s0=B0+h0;
        R=750e3;
        s=s0*sqrt(1-r/R);
        s(r>=R)=0;
        b=Calc_bh_From_sBS(CtrlVar,MUA,s,B,S,rho,rhow);

    elseif contains(UserVar.RunType,"-Tmax-")  % transient starting with SSMax

        if isempty(Fs)
            load("SteadyStateInterpolantsThuleMax10km.mat","Fb","Fs")
        end

        b=Fb(F.x,F.y)  ; s=Fs(F.x,F.y);

    elseif contains(UserVar.RunType,"-Tmin-")  % transient starting with SSMax

        if isempty(Fs)
            load("SteadyStateInterpolantsThuleMin10km.mat","Fb","Fs")
        end

        b=Fb(F.x,F.y)  ; s=Fs(F.x,F.y);

    else

        error("case not found")



    end
end


end




