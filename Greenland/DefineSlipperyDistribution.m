


function   [UserVar,C,m,q,muk,V0]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,F)

persistent FC



% Check if we already have a file with an estimate for C.
if isempty(FC)

    if isfile(UserVar.Files.CInterpolant)

        load(UserVar.Files.CInterpolant,"C","xC","yC")
        FC=scatteredInterpolant(xC,yC,C) ;

    end

end

if ~isempty(FC)

    C=FC(F.x,F.y);
    m=3 ;

else

    m=1 ;
    % u=c tau^m ; example u=10 m/a, tau=80kPa ; m=1; C=10/80=0.125
    C=0.5+zeros(MUA.Nnodes,1);

end


q=[];
muk=[];
V0=[];


end