clc;
clear;
close all;

addpath(genpath(pwd));

%% ============================================================
% Start Parallel Pool
%% ============================================================

if isempty(gcp('nocreate'))
    parpool('local');
end

%% ============================================================
% Algorithms
%% ============================================================

Algorithms = { ...
    'GWO',...
    'WOA',...
    'DIO',...
    'CADIO_GWO'};

nAlgo = length(Algorithms);

%% ============================================================
% Colors
%% ============================================================

Colors10 = [
    0.8500,0.3250,0.0980;
    0.0000,0.4470,0.7410;
    0.9290,0.6940,0.1250;
    0.4940,0.1840,0.5560;
    0.4660,0.6740,0.1880;
    0.3010,0.7450,0.9330;
    0.6350,0.0780,0.1840;
    0.0000,0.5000,0.0000;
    1.0000,0.0000,1.0000;
    0.0000,0.0000,0.0000];

%% ============================================================
% Parameters
%% ============================================================

N = 60;
MaxIter = 300;
dim = 100;

lb = -100;
ub = 100;

Runs = 300;

%% ============================================================
% Result Matrices
%% ============================================================

BestResults = zeros(30,nAlgo);
MeanResults = zeros(30,nAlgo);
StdResults  = zeros(30,nAlgo);

%% ============================================================
% Excel File for All Runs
%% ============================================================

AllRunsFile = sprintf('CEC2017_AllRuns_Dim%d_Runs%d.xlsx',dim,Runs);

if exist(AllRunsFile,'file')
    delete(AllRunsFile);
end

%% ============================================================
% Main Loop
%% ============================================================

for FuncNum = 1:30

    fprintf('\n');
    fprintf('=====================================================\n');
    fprintf('CEC2017 FUNCTION F%d (Dimension = %d)\n',FuncNum,dim);
    fprintf('=====================================================\n');

    figure('Name',['CEC2017_F',num2str(FuncNum)]);
    hold on;

    RunTable = table();

    for a = 1:nAlgo

        fprintf('\n');
        fprintf('-----------------------------------------------------\n');
        fprintf('%s\n',Algorithms{a});
        fprintf('-----------------------------------------------------\n');

        Fitness = zeros(Runs,1);
        AllCurves = zeros(Runs,MaxIter);

        tic;

        parfor r = 1:Runs

            local_fobj = @(x) cec17_func(x',FuncNum);

            [BestScore,~,Curve] = RunAlgorithm( ...
                Algorithms{a},...
                N,...
                MaxIter,...
                lb,...
                ub,...
                dim,...
                local_fobj);

            Fitness(r) = BestScore;
            AllCurves(r,:) = Curve(:)';

        end

        TimeTaken = toc;

        %% Display Every Run

        for r = 1:Runs

            fprintf('Run %3d : %.12e\n',r,Fitness(r));

        end

        %% Statistics

        BestVal = min(Fitness);
        MeanVal = mean(Fitness);
        StdVal  = std(Fitness);

        BestResults(FuncNum,a) = BestVal;
        MeanResults(FuncNum,a) = MeanVal;
        StdResults(FuncNum,a)  = StdVal;

        fprintf('\n');
        fprintf('Completed in %.2f seconds\n',TimeTaken);
        fprintf('Best = %.12e\n',BestVal);
        fprintf('Mean = %.12e\n',MeanVal);
        fprintf('Std  = %.12e\n',StdVal);

        %% Save Runs

        RunTable.(Algorithms{a}) = Fitness;

        %% Average Convergence

        MeanCurve = mean(AllCurves,1);

        semilogy(MeanCurve,...
            'Color',Colors10(a,:),...
            'LineWidth',2);

    end

    %% Plot Settings

    legend(Algorithms,'Location','bestoutside');
    xlabel('Iteration');
    ylabel('Average Best Fitness');
    title(['CEC2017 Function F',num2str(FuncNum),...
        ' (',num2str(dim),'D)']);
    grid on;

    drawnow;

    %% Save All Runs for This Function

    writetable(RunTable,...
        AllRunsFile,...
        'Sheet',['F',num2str(FuncNum)]);

end

%% ============================================================
% Tables
%% ============================================================

FunctionNames = strcat("F",string((1:30)'));

BestTable = array2table( ...
    BestResults,...
    'VariableNames',Algorithms,...
    'RowNames',cellstr(FunctionNames));

MeanTable = array2table( ...
    MeanResults,...
    'VariableNames',Algorithms,...
    'RowNames',cellstr(FunctionNames));

StdTable = array2table( ...
    StdResults,...
    'VariableNames',Algorithms,...
    'RowNames',cellstr(FunctionNames));

%% ============================================================
% Save Statistics
%% ============================================================

Suffix = sprintf('_Dim%d_Runs%d.xlsx',dim,Runs);

writetable(BestTable,...
    ['CEC2017_Best',Suffix],...
    'WriteRowNames',true);

writetable(MeanTable,...
    ['CEC2017_Mean',Suffix],...
    'WriteRowNames',true);

writetable(StdTable,...
    ['CEC2017_Std',Suffix],...
    'WriteRowNames',true);

%% ============================================================
% Display Tables
%% ============================================================

disp(' ');
disp('======================================================');
disp('BEST RESULTS');
disp('======================================================');
disp(BestTable);

disp(' ');
disp('======================================================');
disp('MEAN RESULTS');
disp('======================================================');
disp(MeanTable);

disp(' ');
disp('======================================================');
disp('STD RESULTS');
disp('======================================================');
disp(StdTable);

disp(' ');
disp('======================================================');
disp('RESULTS SAVED SUCCESSFULLY');
disp('======================================================');

disp(['Best  : CEC2017_Best',Suffix]);
disp(['Mean  : CEC2017_Mean',Suffix]);
disp(['Std   : CEC2017_Std',Suffix]);
disp(AllRunsFile);

disp('======================================================');