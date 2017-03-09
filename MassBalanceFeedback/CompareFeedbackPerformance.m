%%
FileName='AccSurfTimeWithMassBalanceFeedback0'; load(FileName,'Acc','Surf','Time')

figure

plot(Time,10*exp(Time),'g'); 

hold on

plot(Time,Surf,'o-.')

hold on 

FileName='AccSurfTimeWithMassBalanceFeedback2'; load(FileName,'Acc','Surf','Time')


plot(Time,Surf,'o-.')

legend('Analytical','Explicit Feedback','Implicit Feedback')

xlabel('time (yr)')
ylabel('Surface elevation (m)')

