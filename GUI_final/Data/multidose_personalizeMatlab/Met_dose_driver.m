load('pop_data_all.mat');
T = readtable('personal_matlab.csv');

age = T{1,7};
if age<= 30
    p = pop_data_all(:,1);
elseif age>30 || age <=60
    p = pop_data_all(:,2); 
else
    p = pop_data_all(:,3);
end

TimeLenG = T.timeGlu';
TimeLenM = T.timeMet';
DoseLen = T.amountMet(1);
DietLen = T.amountGlu(1);


[To1,TotalDo] = dose(p,TimeLenG,TimeLenM,DoseLen,DietLen);      