function AUCcostout = cost_func_glu(x1)


load('synthe_patient.mat');
p = bigTable(2500,:);
p(:,2) = 0;% no exercise
p(:,19) = 196.5;% baseline
p(:,23) = 9; % not diet
p = [p]';
p(11:12)=x1';


TimeLen = 1000;

y0 = [500 0 0 0 196.5 0 0 ]';

[t,y,y2] = Metformin_main(p,y0,TimeLen);

        texp = [0.5,1,1.516,2.017,2.484,2.953,3.906,5.969,7.922,9.922];
        yexp = [98.961,56.106,34.549,37.662,39.481,10.133,11.734,8.312,45.714,77.929]-60;
        
        
        for j=1:length(texp)
            teval = abs(t-texp(j));
            [tmin tindex] = min(teval);
            AUCcostout(j) = (y2(tindex,5)-y0(5))./(y0(5)*100) - yexp(j);
        end

end
