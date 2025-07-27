function [UserVar,LSF,c]=DefineCalving(UserVar,CtrlVar,MUA,F,BCs)

%% To-Do
% Possibly better to write this as 
%
%  [UserVar,LSF,c]=DefineCalving(UserVar,CtrlVar,MUA,LSF,c,F,BCs)
%
% in which case LSF and c are always passed right through by default.
%
% 
% 
%
%%

%%
%
%   [UserVar,LSF,CalvingRate]=DefineCalving(UserVar,CtrlVar,MUA,F,BCs)
%
% Define calving the Level-Set Field (LSF) and the Calving Rate Field (c)
%
% Both the Level-Set Field (LSF) and the Calving-Rate Field (c) must be defined over
% the whole computational domain.
%
%
% The LSF should, in general, only be defined in the beginning of the run and set the
% initial value for the LSF. However, if required, the user can change LSF at any time
% step. The LSF is evolved by solving the Level-Set equation, so any changes done to
% LSF in this m-file will overwrite/replace the previously calculated values for LSF.
%
% The calving-rate field, c, is an input field to the Level-Set equation and needs to
% be defined in this m-file in each call.
%
% The variable F has F.LSF and F.c as subfields. In a transient run, these will be the
% corresponding values from the previous time step.
%
% If you do not want to modify LSF,  set
%
%   LSF=F.LSF
%
%
% Also, if you do not want to modify c, you could set
%
%   c=F.c
%
% However, note that in contrast to LSF, c is never evolved by Úa.  (Think of c as an
% input variable similar to the input as and ab for upper and lower surface balance,
% etc.)
%
% If c is returned as a NaN, ie
%
%       c=NaN;
%
% then the level-set is NOT evolved in time using by solving the level-set equation. This can be usefull if, for example, the
% user simply wants to manually prescribe the calving front position at each time step. 
%
%%

%% initialize LSF
if isempty(F.LSF)   % Do I need to initialize the level set function?


    Xc=UserVar.CalvingFront0.Xc;
    Yc=UserVar.CalvingFront0.Yc;

    % A rough sign-correct initialisation for the LSF
    io=inpoly2([F.x F.y],[Xc(:) Yc(:)]);
    LSF=-ones(MUA.Nnodes,1) ;
    LSF(io)=+1;

    % figure ; PlotMuaMesh(CtrlVar,MUA);   hold on ; plot(F.x(io)/1000,F.y(io)/1000,'or')

    [xc,yc,LSF]=CalvingFrontLevelSetGeometricalInitialisation(CtrlVar,MUA,Xc,Yc,LSF,plot=true);

else
    LSF=F.LSF ;  % remember to pass LSF through, in no initialisation is required
end

%% Define calving rate (if needed)

if  strcmpi(CtrlVar.LevelSetEvolution,"-prescribed-")  

      
    c=nan;   % setting the calving rate to nan implies that the level set is not evolved
    return

end



