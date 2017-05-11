function [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)



as=zeros(MUA.Nnodes,1)+0.3;


% MISMIP+consists of three experiments with different melt rates. Each
% experiment is initialized with mi=0 (no melting), and should begin with a
% stable grounding line crossing the center of the channel on the retrograde
% slope around x =450±10km. Stable in this case means that the ice sheet
% thickness and the grounding-line position is permitted to ?uctuate, but any
% ?uctuations should average to zero over time, and should be of low amplitude
% compared to the response to perturbations. Preliminary experiments indicate
% that,startingfromauniformthicknessof100m,astablestate
% isfoundafteraround20000a.Oneexperiment(Ice0)issimply a control, where the melt
% rate is maintained at mi=0 for 100 years, while the other two (Ice1 and Ice2)
% are intended to study the response to substantial ice shelf ablation.
% Experiment Ice1 is divided into several parts, all beginning with Ice1r, where
% the melt rate given in Eq. (17) is applied from t =0 to t =100a, and is
% expected to produce thinningoftheiceshelf,alossofbuttressing,andgroundingline
% retreat. Ice1ra starts from the state computed at the end of the Ice1r
% simulation and runs at least until t =200a, and optionally until t =1000a,
% with no melting, so that the ice shelf thickens, buttressing is restored and
% the grounding line advances. Preliminary simulations have shown that the
% grounding-line position does not reach its initial steady state within even
% 1000 years. Finally, Ice1rr is optional and continues Ice1r, with the melt
% rate of Eq. (17), until t =1000a. Figure 2 shows example basal-traction and
% melt-rate ?elds calculated at several points during the Ice1r and Ice1ra
% experiments. ExperimentIce2isstructuredinthesamewayasIce1,but a different melt
% rate is applied. The Ice1 melt rate adjusts
% topursuethegroundinglineasitretreats,preventingtheformationofasubstantiveiceshelf.Incontrast,Ice2rprescribes
% asubice-shelfmelt-rateof100ma?1,wherex > 480kmand no melt elsewhere from t =0
% to t =100a, resulting in substantial loss of ice concentrated away from the
% grounding line, as in a sequence of extensive calving events3. Preliminary
% calculations show that the grounding line retreats for



%rhofw=1000;
%L=3.34e5;
%rho=917;
%cw=3974 ;
%Gt=5e-2;
%Gs=1.e3-3;


%uH=u0*tanh(Hc/Hc0);
%Tzd=T0*(b-B)/zref;
%ab=rho*cw*Gt*uH.*Tzd/rhofw/L;

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





end

