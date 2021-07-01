
fileList = dir('./traindata/*.fhr');

for i = 1:length(fileList)
    fileName = fileList(i).name;
    [FHR1,FHR2,TOCO] = fhropen(strcat('./traindata/',fileName));
    [baseline,accelerations,decelerations,falseAcc,falseDec] = aamwmfb(FHR1);

    columns={'FHR','TOCO', 'baseline'}; 
    FHR = reshape(FHR1,length(FHR1),1);
    TOCO = reshape(TOCO,length(TOCO),1);
    baseline = reshape(baseline,length(baseline),1);
    
    [row,col] = size(accelerations);
    accs = [];
    for c = 1:col
        acc = containers.Map;
        acc('start') = fix(accelerations(1,c));
        acc('index') = fix(accelerations(2,c));
        acc('end') = fix(accelerations(3,c));
        accs = [accs,{acc}];
    end

    [row,col] = size(decelerations);
    decs = [];
    for c = 1:col
        dec = containers.Map;
        dec('start') = fix(decelerations(1,c));
        dec('index') = fix(decelerations(2,c));
        dec('end') = fix(decelerations(3,c));
        decs = [decs,{dec}];
    end


    analysisRecord = containers.Map;
    analysisRecord('fhr') = fix(FHR);
    analysisRecord('toco') = fix(TOCO);
    analysisRecord('baseline') = fix(baseline);
    analysisRecord('accs') = accs;
    analysisRecord('decs') = decs;
    json = jsonencode(analysisRecord);
    
    fileName = strrep(fileName,'.fhr','')
    fid = fopen(strcat('./analysisRecord/',fileName,'.json'),'a');
    fprintf(fid,'%s',json); 
    fclose(fid);
end
