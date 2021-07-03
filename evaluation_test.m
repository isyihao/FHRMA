load analyses/expertAnalyses.mat   
fileresults=evaluateaam('aamlu(FHR)',data([data(:).trainingData]==1),'traindata/')