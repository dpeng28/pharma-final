
load('pop_data_all.mat');
T = readtable('personal_matlab.csv');

age = T{1,7};
if age<= 30
    p = pop_data_all(:,1);
    p(23) = 14.4*50;
elseif age>30 || age <=60
    p = pop_data_all(:,2); 
    p(23) = 28.9*50;
else
    p = pop_data_all(:,3);
    p(23) = 13.9*50;
end

TimeLenG = T.timeGlu';
TimeLenM = T.timeMet';
DoseLen = T.amountMet(1);
DietLen = T.amountGlu(1)*1000;

[To1,TotalDo] = dose(p,TimeLenG,TimeLenM,DoseLen,DietLen);       


save multidose.mat To1 TotalDo
