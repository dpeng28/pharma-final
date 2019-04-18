clear all;

y0 = [500 0 0 0  196.5 0]';

admin = [1 1 1 0 0 0];
% 1 = mass of Metaformin in the GI lumen;  ??? initial dosage
% 2 = mass of Metaformin in the GI wall;
% 3 = mass of Metaformin in the liver
% 4 = mass of Metaformin in periphery compartment;
% 5 = blood glucose concentration change 
% 6 = blood glucose concentration 

load('synthe_patient.mat');
p = bigTable(1,:);
p = [p 0 ]';

Yo1 = [];
To1 = [];
TotalDo1=[];
TotalDo2=[];
TotalDo3=[];
TotalDo4=[];
DrugIno = [];
DrugOuto = [];
a=0;
for i = 1:6 
 
    if admin(i) == 1
        y0(1) = y0(1)+500;
        
    else
        y0(1) = y0(1); 
  
    end
    options = odeset('MaxStep',5e-2, 'AbsTol', 1e-5,'RelTol', 1e-5,'InitialStep', 1e-2);
    [T1,Y1] = ode45(@Meformin_eqns,linspace(0,TimeLen,650),y0,options,p);
    TotalD(:,1) = Y1(:,4);%mass in blood
    TotalD(:,2) = Y1(:,2);%amont in wall
    TotalD(:,3) = Y1(:,3); %amount in liver
    DrugIn = zeros([(length(Y1(:,1))) 1]);
    if admin(i) == 1
        
        DrugIn = DrugIn+500;
    else
        
        DrugIn = DrugIn;
    end
    
    
    DrugOut = Y1(:,4); % cumulative drug eliminated from system
    BalanceD = DrugIn - DrugOut - TotalD(:,2) - TotalD(:,3); %(zero = balance)

    if abs(mean(BalanceD))>1e-6
    
        disp('Mass imbalance possible: ')
        disp(BalanceD)
    end
    
    y0 = Y1(end,:);
    
    Yo1 = [Yo1; Y1];
    To1 = [To1;T1+8*(i-1)];
    TotalDo1=[TotalDo1; TotalD(:,1)];
    TotalDo2=[TotalDo2; TotalD(:,2)];
    TotalDo3=[TotalDo3; TotalD(:,3)];
    DrugIno = [DrugIno; DrugIn];
    DrugOuto = [DrugOuto;  DrugOut];
end
%%%BalanceD1 = DrugIno - DrugOuto - TotalDo1 - TotalDo2;