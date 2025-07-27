function UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)
%%
% This routine is called during the run and can be used for saving and/or plotting data.
%
%   UserVar=DefineOutputs(UserVar,CtrlVar,MUA,BCs,F,l,GF,InvStartValues,InvFinalValues,Priors,Meas,BCsAdjoint,RunInfo)
%
% Write your own version of this routine and put it in you local run directory.
%
%
%   This is the m-file you use to define/plot your results.
%
%   You will find all the outputs in the variable F
%
%   The variable F is a structure, and has various fields.
%
%   For example:
%
%   F.s             The upper glacier surface%
%   F.b             The lower glacier surface
%   F.B             The bedrock
%   F.rho           The ice density
%   F.C             Basal slipperiness, i.e. the variable C in the basal sliding law
%   F.AGlen         The rate factor, i.e. the variable A in Glen's flow law
%
%   F.ub            basal velocity in x-direction
%   F.vb            basal velocity in y-direction
%
%   All these variables are nodal variables, i.e. these are the corresponding values at the nodes of the computational domain.
%
%   You find information about the computational domain in the variable MUA
%
%   For example, the x and y coordinates of the nodes are in the nx2 array MUA.coordinates, where n is the number of nodes.
%
%   MUA.coordinates(:,1)    are the nodal x coordinates
%   MUA.coordinates(:,y)    are the nodal y coordinates
%
%
%   BCs             Structure with all boundary conditions
%   l               Lagrange parameters related to the enforcement of boundary
%                   conditions.
%   GF              Grounding floating mask for nodes and elements.
%
%   Note: If preferred to work directly with the variables rather than the respective fields of the structure F, then F can easily be
%   converted into variables using v2struc.
%
%
%
%   Note:  For each call to this m-File, the variable
%
%       CtrlVar.DefineOutputsInfostring
%
%   gives you information about different stages of the run (start, middle
%   part, end, etc.).
%
%   So for example, when Ua calls this m-File for the last time during the
%   run, the variable has the value
%
%     CtrlVar.DefineOutputsInfostring="Last call"
%
%
%%


persistent tVector hVector iCounter

if isempty(tVector)
    tVector=nan(10000,1);
    hVector=tVector;
    iCounter=1;
end


time=CtrlVar.time;
plots='-plot-';

if contains(plots,'-save-')

    % save data in files with running names
    % check if folder 'ResultsFiles' exists, if not create

    if exist(fullfile(cd,UserVar.Outputsdirectory),'dir')~=7
        mkdir(CtrlVar.Outputsdirectory) ;
    end

    if strcmp(CtrlVar.DefineOutputsInfostring,'Last call')==0


        FileName=sprintf('%s/%07i-Nodes%i-Ele%i-Tri%i-kH%i-%s.mat',...
            CtrlVar.Outputsdirectory,round(100*time),MUA.Nnodes,MUA.Nele,MUA.nod,1000*CtrlVar.kH,CtrlVar.Experiment);
        fprintf(' Saving data in %s \n',FileName)
        save(FileName,'UserVar','CtrlVar','MUA','F')

    end

end

r=sqrt(F.x.*F.x+F.y.*F.y) ;
[rMin,iloc]=min(r);
hVector(iCounter)=F.h(iloc);
tVector(iCounter)=F.time;
iCounter=iCounter+1; 




if contains(plots,'-plot-')

    cbar=UaPlots(CtrlVar,MUA,F,F.h,FigureTitle="ice thickness") ;
    title(sprintf("ice thickness at t=%5.2f",F.time)) ;
    title(cbar,"(m)")

    fh0=FindOrCreateFigure("h0(t)") ; 
    plot(tVector,hVector,"or-")
    xlabel("time (yr)")
    ylabel("h(r=0) (m)")


    Fh=scatteredInterpolant(F.x,F.y,F.h);

    xProfile=linspace(-UserVar.R,UserVar.R,50) ;
    hProfile=Fh(xProfile,xProfile*0);

    FindOrCreateFigure("h(x)")
    plot(xProfile/1000,hProfile,"or-")
    title(sprintf("ice thickness profile at t=%5.2f",F.time)) ;
    xlabel("x (km)")
    ylabel("h (m)")



end


end