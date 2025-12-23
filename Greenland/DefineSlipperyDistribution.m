


function   [UserVar,C,m,q,muk,V0]=DefineSlipperyDistribution(UserVar,CtrlVar,MUA,F)

persistent FC DateFileWasLastRead


if isempty(DateFileWasLastRead)
    DateFileWasLastRead=datetime(1971,11,3)  ;
else
    DateFileWasLastRead=datetime(DateFileWasLastRead); % Matlab seems to store datetime variables as strings 
         % and the datetime variables therefore needs to be recreated from that sting.
end

% Check if we already have a file with an estimate for C.

if isfile(UserVar.Files.CInterpolant)

    fileInfo=dir(UserVar.Files.CInterpolant) ; 
    if fileInfo.date-DateFileWasLastRead > 0 % has the file be modified since last time it was read?

        load(UserVar.Files.CInterpolant,"C","xC","yC")
        FC=scatteredInterpolant(xC,yC,C) ;
        DateFileWasLastRead=fileInfo.date;
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