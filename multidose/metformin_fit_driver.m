
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
DoseLen = 500;
DietLen = 39*1000*5;
% TimeLenG = [7 0 0];
% TimeLenM = [7 0 0];
% DoseLen = 500;
% DietLen = 200;


[To1,TotalDo] = dose(p,TimeLenG,TimeLenM,DoseLen,DietLen);       


save multidose.mat To1 TotalDo
plot(To1,TotalDo(:,6))

%% one dose

load('synthe_patient.mat');
p = pop_data_all(:,3); 
p(23) = 28.9*50;
p = [p]';

TimeLen = 1000;%%%%%%%%%%%%%%%%%%%y(6)-->196.5+GI*carbo_weight/100/Vc/weight

y0 = [500 0 0 0 171.5 171.5 0 39*1000*5/p(23) 0 0]'; % y(6) need to be larger than 196.5

[t,y,balance] = Metformin_main(p,y0,TimeLen);

plot(t,y(:,5))
xlabel("Time(mins)")
ylabel("Mass balance of Metformin(mg)")
hold on;

%% fit diet fit
    x1 = [2,3];
    lb = x1./10;
    ub = x1.*10;
    options = optimoptions('lsqnonlin','Display','iter');
    optimal = lsqnonlin(@aucfit,x1,lb,ub,options);
            

 %% fitting
            x1 = [0.458,0.910, 1.01*10^(-2)];%1.88*10^(-3),1.85*10^(-3),...,4.13,0.509
            lb = x1./10;%
            ub = x1.*10;
           
            options = optimoptions('lsqnonlin','Display','iter');
            optimal = lsqnonlin(@cost_func,x1,lb,ub,options);
            p(5:7) = optimal;
            [t,y4,y] = Metformin_main(p,y0,1000);
            save fit.mat t y texp yexp
            %0.6671    0.9408    0.0329
 %%           
            x1 = [2.08,5.42*10^-3];
            lb = x1./100;%
            ub = x1.*100;
           %0.0208    0.5420
            options = optimoptions('lsqnonlin','Display','iter');
            optimal = lsqnonlin(@cost_func_glu,x1,lb,ub,options);
            p(11:12) = optimal;
            [t,y4,y] = Metformin_main(p,y0,1000);
            save fit.mat t y texp yexp
            


%% fitted results
            
%     0.3980    0.8772    0.0176
%     0.3117    0.8026    0.0592
%     0.6671    0.9408    0.0329
%      0.6671    0.9408    0.0329
%     0.8549   73.5137    0.0069    0.0276
%     1.6065    1.6506    0.0118    0.0728
%     [t,y4,y] = Metformin_main(p,y0,1000);
%     plot(t,y4)
% hold on
% scatter(texp,yexp)
    