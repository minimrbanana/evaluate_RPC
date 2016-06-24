function det2idl_LSDA_train(Min_score, Nms_box, withFlow, N_box)
%% function to generate idl files 
% input      Min_score, Nms_label, Nms_box      three parameters
% output     saved idl file

%% gt and annotation dir
% dir setting
dataDir = '/BS/joint-multicut/work/DetectionRes/Ftrain_LC/';
Type = '*.mat';

annoDir = '/BS/siyu-project/work/MulticutMotionTracking/dataset/Ftrain/Trainingset/';

gtdir = '/BS/siyu-project/work/MulticutMotionTracking/dataset/Ftrain/Trainingset/';
folder = dir(gtdir);
folder(1:2)=[];

Type1 = '*.ppm';
Type2 = '*.pgm';

%% generate the det of FBMS59
% store dir setting
% Min_score = 0;
% Nms_label = 0.1;
% Nms_box = 0.4;
boxDirout = sprintf('%.1f_%.1f_%d',Min_score, Nms_box,N_box);
if withFlow
    fid = fopen(['LSDA_' boxDirout '_Flow_train.idl'],'w');
else
    fid = fopen(['LSDA_' boxDirout '_train.idl'],'w');
end
% loop for each folder
weirdGT = [3:8 18:24];
for iter=1:29
choice = find(weirdGT==iter);
if isempty(choice)
    boxDir = [folder(iter).name '/'];
    Files=dir([dataDir boxDir Type]);
    LengthFiles = length(Files);
    
    folderdir = [gtdir boxDir 'GroundTruth/'];
    GTFiles = dir([folderdir Type2]);

    g = 1;
    if size(GTFiles,1)
        GTmat = GTFiles(g).name(1:end-7);  %with _gt -7; without _gt -4
    else
        GTmat = [];
    end
    for boxnum=1:LengthFiles
        boxName = Files(boxnum).name;
        if strcmp(GTmat,boxName(1:end-4))
            filename = [dataDir boxDir boxName];
            temp = load(filename);
            boxes = temp.boxes;
            scores = max(temp.scores,[],2);
            clear temp;

            if withFlow && boxnum~=LengthFiles  
                temp = load(['/BS/joint-multicut/work/DetectionRes/Ftrain_LF/' boxDir boxName(1:end-4) 'bflow.mat']);
                boxesF = temp.boxes;
                scoresF = max(temp.scores,[],2);
                clear temp;
                boxes = [boxes;boxesF];
                scores = [scores;scoresF];
            end
            
            [top_boxes, ~, ~] = prune_boxes(boxes, scores, Min_score, Nms_box);
            if N_box<size(top_boxes,1)% we take first N_box boxes
                top_boxes = top_boxes(1:N_box,:);
            end
            % function to idl
            annoFolder = [annoDir boxDir];
            annoImage = [annoFolder boxName(1:(end-3)) 'jpg'];
            if size(top_boxes,1)>0
                det2idl(annoImage,fid, top_boxes);
            end
            g = g+1;
            if g<=size(GTFiles,1)
                GTmat = GTFiles(g).name(1:end-7);
            end
        end
    end
    fprintf('file %d written\n', iter);
else
    boxDir = [folder(iter).name '/'];
    Files=dir([dataDir boxDir Type]);
    LengthFiles = length(Files);
    
    folderdir = [gtdir boxDir 'GroundTruth/'];
    GTFiles = dir([folderdir Type2]);

    g = 1;
    if size(GTFiles,1)
        GTmat = GTFiles(g).name(1:end-4);  %with _gt -7; without _gt -4
    else
        GTmat = [];
    end
    for boxnum=1:LengthFiles
        boxName = Files(boxnum).name;
        if strcmp(GTmat,boxName(1:end-4))
            filename = [dataDir boxDir boxName];
            temp = load(filename);
            boxes = temp.boxes;
            scores = max(temp.scores,[],2);
            clear temp;

            if withFlow && boxnum~=LengthFiles  
                temp = load(['/BS/joint-multicut/work/DetectionRes/Ftrain_LF/' boxDir boxName(1:end-4) 'bflow.mat']);
                boxesF = temp.boxes;
                scoresF = max(temp.scores,[],2);
                clear temp;
                boxes = [boxes;boxesF];
                scores = [scores;scoresF];
            end
            
            [top_boxes, ~, ~] = prune_boxes(boxes, scores, Min_score, Nms_box);
            if N_box<size(top_boxes,1)% we take first N_box boxes
                top_boxes = top_boxes(1:N_box,:);
            end
            % function to idl
            annoFolder = [annoDir boxDir];
            annoImage = [annoFolder boxName(1:(end-3)) 'jpg'];
            if size(top_boxes,1)>0
                det2idl(annoImage,fid, top_boxes);
            end
            g = g+1;
            if g<=size(GTFiles,1)
                GTmat = GTFiles(g).name(1:end-4);
            end
        end
    end
    fprintf('file %d written\n', iter);
end
end
fclose(fid);
fprintf('Dataset FBMS59 written\n');
end