 


file{1}='ProjectedBFGS';
file{2}='AdjointProjectedGradient' ;
file{3}='MatlabConstrainedMinimisation';

col{1}='b' ; col{2}='r' ; col{3}='g';

figure ; 
for I=1:3
    load(file{I})
    semilogy(JoptVector(:,1),'o-','color',col{I})
    hold on
end

legend('Projected Hessian','Projected gradient','Interior-point')
