function [out1,out2,out3] = Metformin_main(p,y0,TimeLen)


options = odeset('MaxStep',5e-2, 'AbsTol', 1e-5,'RelTol', 1e-5,'InitialStep', 1e-2);
[T1,Y1] = ode45(@Meformin_eqns,linspace(0,TimeLen,650),y0,options,p);

%legend('lumen','wall','liver','pher','base','up')


TotalD(:,1) = Y1(:,4);%mass in blood
TotalD(:,2) = Y1(:,2);%amont in wall
TotalD(:,3) = Y1(:,3); %amount in liver
DrugIn = y0(1) ; % amount in lumen
DrugOut = Y1(:,7); % cumulative drug eliminated from system
BalanceD = DrugIn - DrugOut - TotalD(:,2) - TotalD(:,3)-TotalD(:,1)-Y1(:,1); %(zero = balance)

if abs(mean(BalanceD))>1e-6
    
    disp('Mass imbalance possible: ')
    disp(BalanceD)
end

%save raw.mat T1 Y1 BalanceD
%

out1 = T1;
out2 = Y1(:,4).*(1000)./(p(10)*p(1)); % unit correction: ug/ml or mg/l
out3 = Y1;

end

