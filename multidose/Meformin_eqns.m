function dydt = Meformin_eqns(t,y,p)

weight = p(1); 
kgp = 0.1;%%%%%%%%%

%1 weight - kg
%2 height - cm 
Kgo = p(3);  % decrease
Kgg = p(4);  % increase
Kgl = p(5);
Klp = p(6); %ls
Kpl = p(7);  %sl
Kpg = p(8);  %sg % decrease
Kpo = p(9);  %s0  % decrease
Vc = p(10); % * weight
k_in = p(11);
k_out = p(12);
V_GI_max = p(13);
V_L_max = p(14);
V_p_max = p(15);
V_GI_50 = p(16);
V_L_50 = p(17);
V_p_50 = p(18);
Glu_baseline = p(19);
n_GI =  p(20);
n_L = p(21);
n_p =  p(22);
age = p(23);%% need to change, PAPER 


dydt = zeros(10,1);    % make it a column vector
% drug on glucose and exercise on glucose
% 1 = mass of Metaformin in the GI lumen; 
% 2 = mass of Metaformin in the GI wall;
% 3 = mass of Metaformin in the liver
% 4 = mass of Metaformin in periphery compartment;
% 5 = blood glucose concentration change 
% 6 = blood glucose concentration 


%----------------Original ODEs---------------------%
 dydt(1) =  -y(1)*(Kgo + Kgg);%%% dependent on weight or not ??*p(1);
 dydt(2) =   y(1)*Kgg + y(4)*Kpg - y(2)*Kgl;
 dydt(3) =   y(2)*Kgl + y(4)*Kpl - y(3)*Klp;
 dydt(4) =   y(3)*Klp - y(4)*(Kpl + Kpg + Kpo);
 dydt(7) = y(1)*Kgo+y(4)*Kpo;

%--------------Metformin glucose-lowering effect----------%

%-------------Effect equaitons--------------------------%
 E_L = (V_L_max*y(3)^n_L) / ((V_L_50*1000)^n_L + (y(3))^n_L); %Hill Equation
 E_GI = (V_GI_max*y(2)^n_GI) / ((V_GI_50*1000)^n_GI + y(2)^n_GI); %Hill Equation
 E_p = (V_p_max*y(4)^n_p) / ((V_p_50*1000)^n_p + y(4)^n_p); %Hill Equation

%----------------Add in ODEs----------------------%
 dydt(5) =   k_in*(1 - E_L) - k_out*(1 + E_GI + E_p)*y(5);  %%%%% mg/dl 
 
% Blood concentration
  %describing glucose change related to food/drink 
 
 dydt(6) =  k_in*(1-E_L) - k_out*(1)*(1 + E_GI + E_p)*(y(6))+y(9);
 
dydt(8) = -Kgo*y(8)-kgp*y(8);
dydt(9) = kgp*(y(8))-Kpo*y(9);
dydt(10) = Kgo*y(8)+Kpo*y(9);%+Glu_baseline) + k_in*(1-E_L)*((y(6))/(p(10)*weight));
 % 