clear all, clc
%%
%---Please run Q1_a.m script to obtain weight matrix of virtua patient---%
young_pop = cell2mat(struct2cell(load('young_pop.mat')));

midege_pop = cell2mat(struct2cell(load('mid_pop.mat')));
old_pop = cell2mat(struct2cell(load('old_pop.mat')));
%%
Metliver_young = [];
Metliver_mid = [];
Metliver_old = [];

Glu_young = [];
Glu_mid = [];
Glu_old = [];

AUC_young = [];
AUC_mid = [];
AUC_old = [];

Time_Length = 1000;
% Select adult here:
% Define global parameters

D0 = 500; % mg (will be * ml = ug)
size = 2000;
for Population = 1:3
    switch Population
        case 1
            for i = 1:size
                p = young_pop(i,:);
                p(:,23) = 0; % not diet
                p = [p]';% 
                y0 = [D0 0 0 0 196.5 196.5 0 100 0 0]';
                [T1,Met_all,AUC, blood_glucose_meal,met_liver] = Metformin_main(p,y0,Time_Length);
                Metliver_young = [Metliver_young;met_liver(end)];
                Glu_young = [Glu_young;blood_glucose_meal(end)];
                AUC_young = [AUC_young;AUC];
            end
        case 2
            for i = 1:size
                p = midege_pop(i,:);
                p(:,23) = 0; % not diet
                p = [p]';% 
                y0 = [D0 0 0 0 196.5 196.5 0 100 0 0 ]';
                [T1,Met_all,AUC, blood_glucose_meal,met_liver] = Metformin_main(p,y0,Time_Length);
                Metliver_mid = [Metliver_mid;met_liver(end)];
                Glu_mid = [Glu_mid;blood_glucose_meal(end)];
                AUC_mid = [AUC_mid;AUC];


            end
        case 3
            for i = 1:size
                p = old_pop(i,:);
                p(:,23) = 0; % not diet
                p = [p]';% 
                y0 = [D0 0 0 0 196.5 196.5 0 100 0 0]';
                [T1,Met_all,AUC, blood_glucose_meal,met_liver] = Metformin_main(p,y0,Time_Length);
                Metliver_old = [Metliver_old;met_liver(end)];
                Glu_old = [Glu_old;blood_glucose_meal(end)];
                AUC_old = [AUC_old;AUC];
            end
    end

end
save('met_mean_young.mat', 'Metliver_young')
save('met_mean_mid.mat', 'Metliver_mid')
save('met_mean_old.mat', 'Metliver_old')

save('Glu_young.mat', 'Glu_young')
save('Glu_mid.mat', 'Glu_mid')
save('Glu_old.mat', 'Glu_old')


save('AUC_young.mat', 'AUC_young')
save('AUC_mid.mat', 'AUC_mid')
save('AUC_old.mat', 'AUC_old')

%%
young_weight = myRandomNum(58.6, 20.2, 40, 2000); % kg - generate the weight 
mid_weight = myRandomNum(71, 20.2, 40, 2000); % kg - generate the weight 
old_weight = myRandomNum(74, 20.2, 40, 2000); % kg - generate the weight 
young_pop_data(:,1) = young_weight;
mid_pop_data(:,1) = mid_weight;
old_pop_data(:,1) = old_weight;

young_pop_data = cat(2,young_pop([1:2000],[1:9,11]),Metliver_young,Glu_young,AUC_young);
mid_pop_data = cat(2,midege_pop([1:2000],[1:9,11]),Metliver_mid,Glu_mid,AUC_mid);
old_pop_data = cat(2,old_pop([1:2000],[1:9,11]),Metliver_old,Glu_old,AUC_old);
young_pop_data(:,end) = young_pop_data(:,end)/500
old_pop_data(:,end) = old_pop_data(:,end)/500
mid_pop_data(:,end) = mid_pop_data(:,end)/500

save young_pop_data.mat young_pop_data
save mid_pop_data.mat mid_pop_data
save old_pop_data.mat old_pop_data

%%
