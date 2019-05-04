      %local univariate
%         p = young_pop(1000,:);
%         %p(:,1) = 70;%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %p(:,2) = 1;% no exercise
%         p(:,19) = 196.5;% baseline
%         p(:,23) = 0; % not diet
%         p = [p]';

        p0 = [74, 157, 0.81*1.8*10^-3, 0.81*1.9*10^-3, 0.81*0.56, 0.81*0.774, 0.81*1.809*10^-2, 0.81*3.865, 0.9*0.593, 67.11, 0.81*1.371, 7.2*10^-3, 0.6168, 0.4069, 0.2577, 309.76787, 634.6291, 777.7881, 6.76, 2, 5, 5, 44.947,500];
        TimeLen = 1000;
        
        Output = 6

        y0 = [500 0 0 0 196.5 196.5 0 100 0 0]'; % y(6) need to be larger than 196.5

        [T1,Met_all,auc0, glu0,met0] = Metformin_sens(p0,y0,TimeLen,Output);

        ParamDelta= 0.5;
       % y =ys;
        
        scope = [3,4,5,6,7,8,9,11,24];
        SensAuc =zeros(8,1);
        SensGlu =zeros(8,1);
        SensDrug =zeros(8,1);

        %p_perturb = [p(1); p(2)];
    for i=1:length(scope)
        %%%add if p _perturb change
        
        p=p0;
       
        id = scope(i);
        p(id)=p0(id)*(1.0+ParamDelta);
         if i == 9
            y0(1) = p(24);
        end
        disp(id)
        [T1,Met_all,auc4, glu,met] = Metformin_sens(p,y0,TimeLen,Output);
       % t = [t t1];
       % y = [y y1];
        SensAuc(i) = ((auc4-auc0)/auc0)/((p(id)-p0(id))/p0(id));
        
        SensAbs(i) = ((auc4-auc0)/auc0);
        SensNonNorm(i) = ((auc4-auc0)/(p(id)-p0(id)));
        
        % drug concentration trough 
        SensDrug(i) = ((met(end)-met0(end))/met0(end))/((p(id)-p0(id))/p0(id));
        
        %glucose concentration trough
        SensGlu(i) = ((glu(end)-glu0(end))/glu0(end))/((p(id)-p0(id))/p0(id));

       % SensT = ((y1-ys)./ys)/((p(i)-p0(i))/p0(i));
        %[maxS,indT] = max(abs(SensT));
        %SensTmax(i) = t(indT);

    
    end
    
    %%
    old_sens = cat(2,SensAuc, SensDrug, SensGlu)';
    save('old_sens.txt','old_sens','-ascii')
    
    figure;
    bar(SensAuc)
        figure;
    bar(SensDrug)
        figure;
    bar(SensGlu)

   
    
    
    %%
          %local univariate
        load('synthe_patient.mat');
        p = bigTable(5000,:);
        p(:,1) = 70;%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        p(:,2) = 1;% no exercise
        p(:,19) = 196.5;% baseline
        p(:,23) = 0; % not diet
        p_s = [p]';

        
        TimeLen = 1000;
        
        Output = 6;

        y0 = [500 0 0 0 196.5 196.5 0 ]'; % y(6) need to be larger than 196.5

        [t,auc0,y] = Metformin_sens(p_s,y0,TimeLen,Output);

        ParamDelta= 0.5;
        
        p0 = y0;
        
        y_perturb = [1 6];
    for i=1:length(y_perturb)
        %%%add if p _perturb change
        p=p0;
        p(y_perturb(i))=p0(y_perturb(i))*(1.0+ParamDelta);
        disp(y_perturb(i))
        [t1,auc4(i),y1] = Metformin_sens(p_s,p,TimeLen,Output);
        t = [t t1];
        y = [y y1];
        Sens4(i) = ((auc4(i)-auc0)/auc0)/((p(y_perturb(i))-p0(y_perturb(i)))/p0(y_perturb(i)));
        
        SensAbs(i) = ((auc4(i)-auc0)/auc0);
        SensNonNorm(i) = ((auc4(i)-auc0)/(p(y_perturb(i))-p0(y_perturb(i))));
       % SensT = ((y1-ys)./ys)/((p(i)-p0(i))/p0(i));
        %[maxS,indT] = max(abs(SensT));
        %SensTmax(i) = t(indT);

    
    end
    
    figure;
    bar(Sens4)
    
    save sens(y1y6).mat Sens4