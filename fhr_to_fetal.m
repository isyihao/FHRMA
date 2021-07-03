% clc;clear all;
% addpath('H:\Program Files\Matlab\Polyspace\R2020a\bin\cuslibs\jsonlab-2.0');
% 
% data = [];
% baseline = {};
% accelerations = {};
% decelerations = {};
% filename = {};
% fileList = dir('./y-analysis/*.json');
% for i = 1:length(fileList)
%     fileName = fileList(i).name;
%     jsonData = loadjson(strcat('./y-analysis/' ,fileName)); 
%     baseline{i} = jsonData.baseline;
%     accelerations{i} = jsonData.accelerations;
%     decelerations{i} = jsonData.decelerations;
%     if length(jsonData.accelerations) == 0
%         accelerations{i} = zeros(0,2);
%     end
%     if length(jsonData.decelerations) == 0
%         decelerations{i} = zeros(0,2);
%     end
%     filename{i} = jsonData.filename;
% end
% 
% data = struct('baseline',baseline,'accelerations',accelerations,'decelerations',decelerations,'filename',filename);
% save('./analyses/Y_std2','data') 
% 
% load analyses/expertAnalyses.mat  
% fileresults = evaluateaam('analyses/Y_std2.mat',data([data(:).trainingData]==1),'traindata/')
%  
% A  = median([fileresults(:).MADI])

clear all
fileList = dir('./origin-fhr/*.fhr');
for i = 1:length(fileList)
    fileName = fileList(i).name;
    [FHR1,FHR2,TOCO] = fhropen(strcat('./origin-fhr/',fileName));

    len = length(FHR1);

    if mean(FHR1(:)) > mean(FHR2(:))
        FHR = reshape(FHR1,len,1);
    else
        FHR = reshape(FHR2,len,1);
    end
    TOCO = reshape(TOCO,len,1);
    FMP = zeros(len,1);
   
    fileName = strrep(fileName,'.fhr','')
    
    fetal = containers.Map;
    fetal('FHR1') = fix(FHR);
    fetal('TOCO') = fix(TOCO);
    fetal('FMP') = FMP;
    fetal('fetalNum') = 1;
    fetal('fetalName') = fileName;
    fetal('length') = len;
    json = jsonencode(fetal);
    
    
    fid = fopen(strcat('./fetal/',fileName,'.json'),'a');
    fprintf(fid,'%s',json); 
    fclose(fid);
    disp(strcat(fileName,' is ok   !'));
end
