function [UserVar,LSF,c]=DefineCalving(UserVar,CtrlVar,MUA,F,BCs)


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
% Also, if you do not want to modify c, you could in prinicple set
%
%   c=F.c
%
% However, note that in contrast to LSF, c is never evolved by Úa.  (Think of c as an
% input variable similar to the input as and ab for upper and lower surface balance,
% etc.)
%
% Initilizing the LSF is the task of the user and needs to be done in this m-file.
% Typically LSF is defined as a signed distance function from the initial calving
% front position. There are various ways of doing this and you might find the matlab
% function
%
%   pdist2
%
% usefull to do this. Also look at
%
% Note: Currenlty only prescribed calving front movements are allowed. 
%       So define LSF in every call. 
%%


% LSF=F.LSF  ; %

c=[] ;

if F.time > 2
    
    
    if UserVar.InitialGeometry=="-MismipPlus-"
        
        
        F.GF=IceSheetIceShelves(CtrlVar,MUA,F.GF);
        NodesSelected=MUA.coordinates(:,1)>500e3 & F.GF.NodesDownstreamOfGroundingLines;
        % ab = -(h-hmin)  , dab=-1 ;
        
        LSF=zeros(MUA.Nnodes,1)+ 1 ; 
        LSF(NodesSelected)=-1;
        
        
        
    else  % flow-line example
        
        % LSF set equal to signed distance from x=xc
        xc=500e3;  % this is the initial calving front
        LSF=xc-MUA.coordinates(:,1) ;
        
    end
    
    
else
    
    LSF=1 ; % just some positive number to indicate that there is ice in all of the domain
    
end


