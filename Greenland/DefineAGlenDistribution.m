
function   [UserVar,A,n]=DefineAGlenDistribution(UserVar,CtrlVar,MUA,F)

persistent FA DateFileWasLastRead



if isempty(DateFileWasLastRead)
    DateFileWasLastRead=datetime(1971,11,3)  ;
else
    DateFileWasLastRead=datetime(DateFileWasLastRead); % Matlab seems to store datetime variables as strings 
         % and the datetime variables therefore needs to be recreated from that sting.
end



if isfile(UserVar.Files.AInterpolant)

    fileInfo=dir(UserVar.Files.AInterpolant) ; 
    if fileInfo.date-DateFileWasLastRead > 0 % has the file be modified since last time it was read?

        load(UserVar.Files.AInterpolant,"AGlen","xA","yA")
        FA=scatteredInterpolant(xA,yA,AGlen) ;
        DateFileWasLastRead=fileInfo.date;
    end


end



if ~isempty(FA)

    A=FA(F.x,F.y);
    n=3 ; % assuming this was the value used, can be changed by creating an interpolant for n as well

else

    n=3;
    T=-10 ;
    A=AGlenVersusTemp(T)+zeros(MUA.Nnodes,1) ;
   
end


end

