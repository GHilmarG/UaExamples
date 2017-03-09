
%%
C3IN=load('Nod3-I-ga0k000000gs0k000000-iC-0-logC-AdjointRestart');
C3MN=load('Nod3-M-ga0k000000gs0k000000-iC-0-logC-AdjointRestart');

C6IN=load('Nod6-I-ga0k000000gs0k000000-iC-0-logC-AdjointRestart');
C6MN=load('Nod6-M-ga0k000000gs0k000000-iC-0-logC-AdjointRestart');

C3ME=load('Nod3-M-ga0k000000gs0k000000-iC-1-logC-AdjointRestart');

figure

Normalize=C3IN.RunInfo.Inverse.J(1);
semilogy(C3IN.RunInfo.Inverse.Iterations,C3IN.RunInfo.Inverse.J/Normalize,'.-','LineWidth',1,'Color','r')
hold on
semilogy(C3MN.RunInfo.Inverse.Iterations,C3MN.RunInfo.Inverse.J/Normalize,'x-','LineWidth',2,'Color','r')
semilogy(C6IN.RunInfo.Inverse.Iterations,C6IN.RunInfo.Inverse.J/Normalize,'.-','LineWidth',1,'Color','b')
semilogy(C6MN.RunInfo.Inverse.Iterations,C6MN.RunInfo.Inverse.J/Normalize,'x-','LineWidth',2,'Color','b')

Normalize=C3ME.RunInfo.Inverse.J(1);
semilogy(C3ME.RunInfo.Inverse.Iterations,C3ME.RunInfo.Inverse.J/Normalize,'o-','LineWidth',2,'Color','r')


legend('I3N','M3N','I6N','M6N','I3E')


xlabel('Iterations')
ylabel('J')