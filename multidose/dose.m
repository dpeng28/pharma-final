
function [To1,TotalDo] = dose(p,TimeLenG,TimeLenM,DoseLen,DietLen)

%p(:,2) = 0;% no exercise
%p(:,19) = 196.5;% baseline
p = [p]';

mat = horzcat([0, 0, 0]', TimeLenG');
mat2 = horzcat([1,1,1]',TimeLenM');
mat = vertcat(mat,mat2);
mat = sortrows(mat,2);
mat = vertcat(mat,[-1,24]);
n = 1;
while  (n<=length(mat))
    if mat(n,2) <0
        %print(n)
        mat(n,:) = [];
        
    end
    n = n+1;
end
b = mat(1,2);
mat2 = mat;
for n=1:length(mat)
    if n == 1
        mat2(n,2)=mat(n,2)-b;
        disp(mat2)
    else
        
        mat2(n,2)=mat(n,2)-mat(n-1,2);
        disp(mat2)
    end
end


mat = mat2;
y0 = [0 0 0 0 171.5 171.5 0 0 0 0]';

Yo1 = [];
To1 = [];
TotalDo1=[];
TotalDo2=[];
TotalDo3=[];
TotalDo4=[];
TotalDo5=[];
TotalDo6=[];
DrugIno = [];
DrugOuto = [];
DrugIn = zeros(650,1);
a=0;
logic = false;
i = 1;
while (i <=(length(mat)-1))
    disp(i)
%     if logic
%         i = i+1;
%         logic = false;
%     end
    if (mat(i,1)==1)&&(mat(i+1,2)~=0)
        y0(1)=y0(1)+DoseLen;
        DrugIn = DrugIn+DoseLen ;
        time = mat(i+1,2);
        i = i+1;
    elseif (mat(i,1)==0)&&(mat(i+1,2)~=0)
        y0(8)=y0(8)+DietLen/p(23);
        time = mat(i+1,2);
        i = i+1;
    elseif (mat(i+1,2)==0)&&(i <=(length(mat)-2))
        y0(1)=y0(1)+DoseLen;
        DrugIn = DrugIn+DoseLen ;
        y0(8)=y0(8)+DietLen/p(23);
        time = mat(i+2,2);
        i=i+2;
        logic = true;
    elseif (i>1&&mat(i,2)==0)
        continue
    elseif (mat(i+1,1)==-1)
        y0 = y0;
        time = mat(i+1,2);

    end
    options = odeset('MaxStep',5e-2, 'AbsTol', 1e-5,'RelTol', 1e-5,'InitialStep', 1e-2);
    [T1,Y1] = ode45(@Meformin_eqns,linspace(0,time*60,650),y0,options,p);
    
    TotalD(:,1) = Y1(:,4);%mass in blood
    TotalD(:,2) = Y1(:,2);%amont in wall
    TotalD(:,3) = Y1(:,3); %amount in liver
    TotalD(:,4) = Y1(:,1);
    %DrugIn = DrugIn+DoseLen ; % amount in lumen
    DrugOut = Y1(:,7); % cumulative drug eliminated from system

    y0 = Y1(end,:);
    
    Yo1 = [Yo1; Y1];
    if i-1~=0
        if logic
            a = a+mat(i-2,2)*60;
            %logic = false;
            disp("aaa")
            logic = false;
        else
            a = a+mat(i-1,2)*60;
        end
        disp(a)
        To1 = [To1;T1+a];
    else
        To1 = [To1;T1];
    end
    
    TotalDo1=[TotalDo1; TotalD(:,1)];
    TotalDo2=[TotalDo2; TotalD(:,2)];
    TotalDo3 = [TotalDo3;TotalD(:,3)];
    TotalDo4 = [TotalDo4;TotalD(:,4)];
    TotalDo5 = [TotalDo5;Y1(:,5)];
    TotalDo6 = [TotalDo6;Y1(:,6)];
    DrugIno = [DrugIno; DrugIn];
    DrugOuto = [DrugOuto;  DrugOut];
end
BalanceD1 = DrugIno - DrugOuto - TotalDo1 - TotalDo2 - TotalDo3 - TotalDo4;

if abs(mean(BalanceD1))>1e-6
    
    disp('Mass imbalance possible: ')
    %disp(BalanceD1)
end

TotalDo = [TotalDo1 TotalDo2 TotalDo3 TotalDo4 TotalDo5 TotalDo6];

%plot(To1, TotalDo6)


%%%%%%%save dose-1.mat To1 TotalDo

end

%%
