      %local univariate
        load('synthe_patient.mat');
        p = bigTable(5000,:);
        p(:,1) = 70;%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        p(:,2) = 1;% no exercise
        p(:,19) = 196.5;% baseline
        p(:,23) = 0; % not diet
        p = [p]';

        p0 =p;
        TimeLen = 1000;
        
        Output = 6

        y0 = [500 0 0 0 196.5 196.5 0 ]'; % y(6) need to be larger than 196.5

        [t,auc0,ys] = Metformin_sens(p0,y0,TimeLen,Output);

        ParamDelta= 0.5;
        y =ys;
        
        
        %p_perturb = [p(1); p(2)];
    for i=1:length(p)
        %%%add if p _perturb change
        p=p0;
        p(i)=p0(i)*(1.0+ParamDelta);
        disp(i)
        [t1,auc4(i),y1] = Metformin_sens(p,y0,TimeLen,Output);
        t = [t t1];
        y = [y y1];
        Sens4(i) = ((auc4(i)-auc0)/auc0)/((p(i)-p0(i))/p0(i));
        
        SensAbs(i) = ((auc4(i)-auc0)/auc0);
        SensNonNorm(i) = ((auc4(i)-auc0)/(p(i)-p0(i)));
       % SensT = ((y1-ys)./ys)/((p(i)-p0(i))/p0(i));
        %[maxS,indT] = max(abs(SensT));
        %SensTmax(i) = t(indT);

    
    end
    
    figure;
    bar(Sens4)
    
    
   
    
    
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