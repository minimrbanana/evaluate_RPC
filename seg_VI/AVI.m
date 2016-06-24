%% plot average VI wrt # boxes
% store average vi for each number of box and each sequence
N_box = 20;
seg_dir = '/BS/siyu-project/work/MulticutMotionTracking/dataset/Ftrain/gtSeg/';
h5_LSDA_dir = '/BS/joint-multicut-2/work/Tracking_result/EXP_idx_37/Train/';
h5_FRCNN_dir = '/BS/joint-multicut-2/work/Tracking_result/EXP_idx_38/Train/';
folder =dir(seg_dir);
folder(1:2)=[];

load('vi.mat');
avi_l=zeros(20,29);
avi_f=zeros(20,29);
count_l=zeros(20,29);
count_f=zeros(20,29);
for i=1:size(folder,1)
    fprintf('prosessing sequence%d\n', i);
    f_name = [seg_dir folder(i).name '/gt.mat'];
    temp = load(f_name);
    gtInfo = temp.gtInfo;
    frame = gtInfo.frameNums;
    box_LSDA = marray_load([h5_LSDA_dir folder(i).name '/' folder(i).name '_problem.h5'], 'boxes');
    box_FRCNN= marray_load([h5_FRCNN_dir folder(i).name '/' folder(i).name '_problem.h5'], 'boxes');
    VI_L=zeros(size(box_LSDA,1),1);
    VI_F=zeros(size(box_FRCNN,1),1);
    sum_listL=0;
    sum_listF=0;
    for j=1:size(frame,2)
        % segment of LSDA of the frame
        cur_frame = frame(j);
        box_list = find(box_LSDA(:,6)==cur_frame);
        numDetection = min(size(box_list,1),N_box);
        box_list = box_list(1:numDetection);
        for k=1:size(box_list,1)
            avi_l(k,i)=avi_l(k,i)+vi_l{i}(sum_listL+k);
            count_l(k,i)=count_l(k,i)+1;
        end
        sum_listL=sum_listL+length(box_list);

        % segment of FRCNN of the frame
        box_list = find(box_FRCNN(:,6)==cur_frame);
        numDetection = min(size(box_list,1),N_box);
        box_list = box_list(1:numDetection);
        for k=1:size(box_list,1)
            avi_f(k,i)=avi_f(k,i)+vi_f{i}(sum_listF+k);
            count_f(k,i)=count_f(k,i)+1;
        end 
        sum_listF=sum_listF+length(box_list);
    end
end
%% 
AVI_L = sum(avi_l,2)./sum(count_l,2);
AVI_F = sum(avi_f,2)./sum(count_f,2);
f=figure(1);
plot(AVI_L,'r','LineWidth',4);
hold on;
plot(AVI_F,'b','LineWidth',4);
set(gca, 'FontSize',  16);
set(ylabel('average variation of information'), 'FontSize',  16);
set(xlabel('# detection'), 'FontSize',  16);
axis([1,20,0.25,0.45]);
legend('Selective search segmentation','Deeplab segmentation','Location','northwest');
set(f,'PaperUnits','normalized');
set(f,'PaperPosition', [0 0 1 1]);
set(f,'PaperOrientation','landscape');
print(1,'-dpdf','AVI');





