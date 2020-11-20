function [UserVar,as,ab]=DefineMassBalance(UserVar,CtrlVar,MUA,time,s,b,h,S,B,rho,rhow,GF)



as=zeros(MUA.Nnodes,1)+0.3;




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

