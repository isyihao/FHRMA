clc;clear all;
fileList = dir('./origin-fhr/*.fhr');

for i = 1:length(fileList)
    fileName = fileList(i).name;
    [FHR1,FHR2,TOCO] = fhropen(strcat('./origin-fhr/',fileName));
    
    FHR=max([FHR1;FHR2]);
    
    [baseline,accelerations,decelerations,falseAcc,falseDec] = aamwmfb(FHR);

 
    FHR = reshape(FHR,length(FHR),1);
    TOCO = reshape(TOCO,length(TOCO),1);
    baseline = reshape(baseline,length(baseline),1);
    
    [row,col] = size(accelerations);
    accs = [];
    for c = 1:col
        acc = containers.Map;
        acc('start') = fix(accelerations(1,c)*4);
        acc('end') = fix(accelerations(2,c)*4);
        acc('index') = fix(accelerations(3,c)*4);
        acc('reliability') = 100;
        acc('marked') = true;
        accs = [accs,{acc}];
    end

    [row,col] = size(decelerations);
    decs = [];
    for c = 1:col
        dec = containers.Map;
        dec('start') = fix(decelerations(1,c)*4);
        dec('end') = fix(decelerations(2,c)*4);
        dec('index') = fix(decelerations(3,c)*4);
        dec('reliability') = 100;
        dec('marked') = 1;
        dec('type') = 'DD';
        decs = [decs,{dec}];
    end


    analysisRecord = containers.Map;
    analysisRecord('fhr') = fix(FHR);
    analysisRecord('toco') = fix(TOCO);
    analysisRecord('baseline') = fix(baseline);
    analysisRecord('accs') = accs;
    analysisRecord('decs') = decs;
    analysisRecord('length') = length(FHR1);
    analysisRecord('fetalName') = fileName;
    json = jsonencode(analysisRecord);
    
    fileName = strrep(fileName,'.fhr','')
    fid = fopen(strcat('./analysisRecord/',fileName,'.json'),'a');
    fprintf(fid,'%s',json); 
    fclose(fid);
end
