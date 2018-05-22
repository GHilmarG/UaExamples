
%%
C3M=load('IR--UaOptimization-Nod3-M-Adjoint-Cga0k000000-Cgs0k000000-Aga0k000000-Ags0k000000-0-0-logC','RunInfo');
C3I=load('IR--UaOptimization-Nod3-I-Adjoint-Cga0k000000-Cgs0k000000-Aga0k000000-Ags0k000000-0-0-logC','RunInfo');
C3F=load('IR--UaOptimization-Nod3-I-FixPoint-Cga0k000000-Cgs0k000000-Aga0k000000-Ags0k000000-0-0-logC','RunInfo');



figure

Normalize=C3I.RunInfo.Inverse.J(1);
semilogy(C3M.RunInfo.Inverse.Iterations,C3M.RunInfo.Inverse.J/Normalize,'.-','LineWidth',1,'Color','r')
hold on
semilogy(C3I.RunInfo.Inverse.Iterations,C3I.RunInfo.Inverse.J/Normalize,'x-','LineWidth',2,'Color','r')
semilogy(C3F.RunInfo.Inverse.Iterations,C3F.RunInfo.Inverse.J/Normalize,'.-','LineWidth',1,'Color','b')


legend('3M','3I','3F')


xlabel('Iterations')
ylabel('J')