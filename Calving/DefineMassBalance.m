function [UserVar,as,ab,dasdh,dabdh]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)



as=zeros(MUA.Nnodes,1)+0.3;

dasdh=[]; dabdh=[];


if contains(UserVar.RunType,"-1dAnalyticalIceShelf-") || contains(UserVar.RunType,"-1dIceShelf-") 
    as=0.3+zeros(MUA.Nnodes,1) ; 
    ab=0+zeros(MUA.Nnodes,1) ; 
    dasdh=zeros(MUA.Nnodes,1) ;
    dabdh=zeros(MUA.Nnodes,1) ;
    
%     if contains(UserVar.RunType,"-MeltFeedback-") 
%         
%         x=MUA.coordinates(:,1) ; 
%         I=x>200e3 ; 
%         hmin=1; 
%         ab(I) = (hmin-h(I)) ; 
%         as(I)= 0 ; 
%         dabdh(I) = -1; 
%         
%     end
    
    return
end


switch UserVar.MassBalanceCase
    
    case 'ice0'
        
        % basal melt always zero
        ab=zeros(MUA.Nnodes,1);
        
    case {'ice1r','ice1ra','ice1rr'}
        
        % There is not difference between ice1r and ice1rr exepct the run time
        % ice1ra has no melt for t>100 years
        if time > 100 && contains(UserVar.MassBalanceCase,'ice1ra')
            
            ab=zeros(MUA.Nnodes,1);
            
        else
            
            Hc0=75;
            Omega=0.2 ;
            z0=-100;
            ab=-Omega*tanh((b-B)/Hc0).* max(z0-b,0);
            ab=ab.*(1-GF.node);
            
        end

        
    case 'ice2ra'
        
        % basal metl at 100 m/a for x>48km for the first 100 years, then zero
        if time<=100
            
            ab=zeros(MUA.Nnodes,1);
            I=MUA.coordinates(:,1)>480e3;
            ab(I)=-100;
            ab=ab.*(1-GF.node);
            
            %test=min(h+CtrlVar.dt*ab)
            if test<CtrlVar.ThickMin
               fprintf(' melting more ice than available locally\n') 
               I=(h+CtrlVar.dt*ab)<0;
               ab(I)=(CtrlVar.ThickMin-h(I))/CtrlVar.dt+0.01;
             
            end
            
            
        else
            ab=zeros(MUA.Nnodes,1);
        end
        
    case 'ice2rr'
        
        ab=zeros(MUA.Nnodes,1);
        I=MUA.coordinates(:,1)>480e3;
        ab(I)=-100;
        ab=ab.*(1-GF.node);
    otherwise
        
        error('case not found')
        
end

if contains(UserVar.RunType,"-CalvingThroughMassBalanceFeedback-")
    
    % Here a fictitious basal melt distribution is applied over the ice shelf downstream
    % of x=400km for the first few years to melt away all/most floating ice. 
    %
    % The melt is prescribed as a function of ice thickness and to speed things up
    % the mass-balance feedback is provided here as well. This requires setting 
    %
    %   CtrlVar.MassBalanceGeometryFeedback=3;
    %
    % in DefineInitialInputs.m
    %
    
    dabdh=zeros(MUA.Nnodes,1) ;
    dasdh=zeros(MUA.Nnodes,1) ;
    
    if (CtrlVar.time+CtrlVar.dt)  < 5
        
        GF=IceSheetIceShelves(CtrlVar,MUA,GF);
        NodesSelected=MUA.coordinates(:,1)>400e3 & GF.NodesDownstreamOfGroundingLines;
        
        % ab = -(h-hmin)  , dab=-1 ;
        ab(NodesSelected)=-(h(NodesSelected)-CtrlVar.ThickMin) ;
        dabdh(NodesSelected)=-1;
        
        
    end
    
end




end

