%%
%M=dlmread('CompareAnalyticalNumerical.txt');
M=dlmread('CompareNumericalNumerical.txt');


Nele=M(:,1) ;
nod=M(:,2);
Nnodes=M(:,8);
uError=M(:,4) ; 
vError=M(:,5) ; 
wError=M(:,6) ; 
 

ind3=nod==3; 
ind6=nod==6;
ind10=nod==10;

figure 
subplot(1,3,1)
loglog(Nele(ind3),uError(ind3),'r-o') ; hold on
loglog(Nele(ind6),uError(ind6),'b-o')
loglog(Nele(ind10),uError(ind10),'c-o') ; title('u') 
ylabel(' rms error ') ; xlabel(' # elements ')
legend('3','6','10')

subplot(1,3,2)
loglog(Nele(ind3),vError(ind3),'r-o') ; hold on
loglog(Nele(ind6),vError(ind6),'b-o')
loglog(Nele(ind10),vError(ind10),'c-o') ; title('v') 
ylabel(' rms error ') ; xlabel(' # elements ')
legend('3','6','10')

subplot(1,3,3)
loglog(Nele(ind3),wError(ind3),'r-o') ; hold on
loglog(Nele(ind6),wError(ind6),'b-o') ; 
loglog(Nele(ind10),wError(ind10),'c-o') ; title('w') 
ylabel(' rms error ') ; xlabel(' # elements ')
legend('3','6','10')

%%
figure 
subplot(1,3,1)
loglog(Nnodes(ind3),uError(ind3),'r-o') ; hold on
loglog(Nnodes(ind6),uError(ind6),'b-o') ; title('u') 
loglog(Nnodes(ind10),uError(ind10),'c-o')
ylabel(' rms error ') ; xlabel(' # nodes ')
legend('3','6','10')

subplot(1,3,2)
loglog(Nnodes(ind3),vError(ind3),'r-o') ; hold on
loglog(Nnodes(ind6),vError(ind6),'b-o') ; title('v') 
loglog(Nnodes(ind10),vError(ind10),'c-o')
ylabel(' rms error ') ; xlabel(' # nodes ')
legend('3','6','10')


subplot(1,3,3)
loglog(Nnodes(ind3),wError(ind3),'r-o') ; hold on
loglog(Nnodes(ind6),wError(ind6),'b-o') ; title('w') 
loglog(Nnodes(ind10),wError(ind10),'c-o')
ylabel(' rms error ') ; xlabel(' # nodes ')
legend('3','6','10')