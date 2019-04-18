function AUCcostout = cost_func(x1)


load('synthe_patient.mat');
p = bigTable(5000,:);
p(:,1) = 70;%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p(:,2) = 0;% no exercise
p(:,19) = 196.5;% baseline
p(:,23) = 9; % not diet
p = [p]';
p(5:7)=x1(1:3)';


TimeLen = 1000;

y0 = [500 0 0 0 196.5 196.5 0 ]'; % y(6) need to be  196.5 or higher

[t,y,y2] = Metformin_main(p,y0,TimeLen);

        texp = [0,27.097,57.431,95.813,121.866,158.299,184.338,243.706,373.883,495.73,615.491,733.174];
        yexp = [0,0.435,0.87,1.078,1.083,1.095,1.188,1.085,0.568,0.323,0.188,0.113];
        
        
        for j=1:length(texp)
            teval = abs(t-texp(j));
            [tmin tindex] = min(teval);
            AUCcostout(j) = y(tindex) - yexp(j);
        end

end

