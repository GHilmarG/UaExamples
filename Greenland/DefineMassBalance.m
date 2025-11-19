

function  [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,F)


persistent Fas DateFileWasLastRead


if isempty(DateFileWasLastRead)
    DateFileWasLastRead=datetime(1971,11,3)  ;
else
    DateFileWasLastRead=datetime(DateFileWasLastRead); % Matlab seems to store datetime variables as strings
    % and the datetime variables therefore needs to be recreated from that sting.
end

% Check if we already have a file with the Fas interpolant

if isfile(UserVar.Files.CInterpolant)

    fileInfo=dir(UserVar.Files.FasInterpolant) ;
    if fileInfo.date-DateFileWasLastRead > 0 % has the file be modified since last time it was read?

        load(UserVar.Files.FasInterpolant,"Fas")
        DateFileWasLastRead=fileInfo.date;
    end


end


if ~isempty(Fas)

    as=Fas(F.x,F.y).*1000./F.rho; 

else

    as=1+zeros(MUA.Nnodes,1);

end


ab=zeros(MUA.Nnodes,1);
dasdh=[];
dabdh =[];

%  UaPlots(CtrlVar,MUA,F,as,FigureTitle="as")  
%  CM=cmocean('-balanced',25,'pivot',0) ; colormap(CM);  

end

