
load('pop_data_all.mat');
T = readtable('personal_matlab.csv');

age = 66;
if age<= 30
    p = pop_data_all(:,1);
    p(23) = 14.4*50;
elseif age>30 && age <=60
    p = pop_data_all(:,2); 
    p(23) = 28.9*50;
else
    p = pop_data_all(:,3);
    p(23) = 13.9*50;
end

TimeLenG = [7 12 19];
TimeLenM = [7 12 19];
DoseLen = 250;
DietLen = 50*1000;
% TimeLenG = [7 0 0];
% TimeLenM = [7 0 0];
% DoseLen = 500;
% DietLen = 200;


[To1,TotalDo,AUC,D,C] = dose(p,TimeLenG,TimeLenM,DoseLen,DietLen);       

y = [AUC/500,D(3),C(3)];
x = [x; y];



save multidose.mat To1 TotalDo
plot(To1,TotalDo(:,6))
xlabel("Time(mins)")
ylabel("metformin amount mg")


%%
c = categorical({'AUC of drug conc','Ctrough of drug','Ctrough of glucose'});
%bar(c,[AUC/500,D(3),C(3)])
y = [AUC/500,D(3),C(3)];
x = [x y];


%% one dose

load('synthe_patient.mat');
p = pop_data_all(:,3); 
p(23) = 28.9*50;
p = [p]';

TimeLen = 1000;%%%%%%%%%%%%%%%%%%%y(6)-->196.5+GI*carbo_weight/100/Vc/weight

y0 = [200 0 0 0 171.5 171.5 0 39*1000*5/p(23) 0 0]'; % y(6) need to be larger than 196.5

[t,y,balance] = Metformin_main(p,y0,TimeLen);

plot(t,y(:,3))
xlabel("Time(mins)")
ylabel("drug amount(mg)")
%legend("500mg","700mg","1500mg","550mg","200mg")
hold on;


    