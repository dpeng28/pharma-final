
%% one dose

load('synthe_patient.mat');
p = bigTable(5000,:);
p(:,1) = 70;%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p(:,2) = 0;% no exercise
p(:,19) = 196.5;% baseline
p(:,23) = 0; % not diet
p = [p]';


TimeLen = 1000;

y0 = [500 0 0 0 196.5 0 0 ]'; % y(6) need to be larger than 196.5

[t,y_4,y] = Metformin_main(p,y0,TimeLen);

plot(t,y(:,6))
hold on;

 %% fitting
            x1 = [0.458,0.910,1.01*10^(-2)];%1.88*10^(-3),1.85*10^(-3),...,4.13,0.509
            lb = x1./100;%
            ub = x1.*100;
           
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
    