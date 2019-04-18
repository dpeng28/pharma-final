clear all;

load('synthe_patient.mat');
p = bigTable(5000,:);
p(:,1) = 70;%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p(:,2) = 0;% no exercise
p(:,19) = 196.5;% baseline
p(:,23) = 0; % not diet
p = [p]';


TimeLen = [1000 1000 1000 1000];

y0 = [0 0 0 0 196.5 200 0 ]'; % y(6) need to be larger than 196.5

Yo1 = [];
To1 = [];
TotalDo1=[];
TotalDo2=[];
TotalDo3=[];
TotalDo4=[];
DrugIno = [];
DrugOuto = [];
DrugIn = zeros(650,1);
a=0;
for i = 1:length(TimeLen)

        y0(1) = y0(1)+500;

    options = odeset('MaxStep',5e-2, 'AbsTol', 1e-5,'RelTol', 1e-5,'InitialStep', 1e-2);
    [T1,Y1] = ode45(@Meformin_eqns,linspace(0,TimeLen(i),650),y0,options,p);
    
    TotalD(:,1) = Y1(:,4);%mass in blood
    TotalD(:,2) = Y1(:,2);%amont in wall
    TotalD(:,3) = Y1(:,3); %amount in liver
    TotalD(:,4) = Y1(:,1);
    DrugIn = DrugIn+500 ; % amount in lumen
    DrugOut = Y1(:,7); % cumulative drug eliminated from system

    y0 = Y1(end,:);
    
    Yo1 = [Yo1; Y1];
    if i-1~=0
        a = a+TimeLen(i-1);
        To1 = [To1;T1+a];
    else
        To1 = [To1;T1];
    end
    TotalDo1=[TotalDo1; TotalD(:,1)];
    TotalDo2=[TotalDo2; TotalD(:,2)];
    TotalDo3 = [TotalDo3;TotalD(:,3)];
    TotalDo4 = [TotalDo4;TotalD(:,4)];
    DrugIno = [DrugIno; DrugIn];
    DrugOuto = [DrugOuto;  DrugOut];
end
BalanceD1 = DrugIno - DrugOuto - TotalDo1 - TotalDo2 - TotalDo3 - TotalDo4;

if abs(mean(BalanceD1))>1e-6
    
    disp('Mass imbalance possible: ')
    disp(BalanceD1)
end

plot(To1,Yo1(:,5))


%%
