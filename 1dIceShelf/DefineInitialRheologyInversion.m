
    
    function [s_prior,b_prior,S_prior,B_prior,AGlen_prior,C_prior,n_prior,m_prior,rho_prior,rhow_prior]=DefineInitialRheologyInversion(Experiment,coordinates,s,b,S,B,AGlen,C,n,m,CtrlVar)

        error('sdfa')
        s_prior=s;
        b_prior=b;
        S_prior=S;
        B_prior=B;
        AGlen_prior=AGlen;
        C_prior=C*0+mean(C);
        n_prior=n;
        m_prior=m;
        rho_prior=rho;
        rhow_prior=rhow;
        
        fprintf(' Inverse experiment with n=%-g and m=%-g \n',n,m)
end
