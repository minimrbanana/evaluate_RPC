%% evaluate segmentation via variation of information
% Ftrain
% set number of segments to calculate
N_box = 20;
seg_dir = '/BS/siyu-project/work/MulticutMotionTracking/dataset/Ftrain/gtSeg/';
h5_LSDA_dir = '/BS/joint-multicut-2/work/Tracking_result/EXP_idx_37/Train/';
h5_FRCNN_dir = '/BS/joint-multicut-2/work/Tracking_result/EXP_idx_38/Train/';
folder =dir(seg_dir);
folder(1:2)=[];
vi_f=cell(size(folder,1),1);
vi_l=cell(size(folder,1),1);
for i=1:size(folder,1)
    fprintf('prosessing sequence%d\n', i);
    f_name = [seg_dir folder(i).name '/gt.mat'];
    temp = load(f_name);
    gtInfo = temp.gtInfo;
    frame = gtInfo.frameNums;
    segments = gtInfo.Segment;
    box_LSDA = marray_load([h5_LSDA_dir folder(i).name '/' folder(i).name '_problem.h5'], 'boxes');
    seg_LSDA = marray_load([h5_LSDA_dir folder(i).name '/' folder(i).name '_problem.h5'], 'segments');
    box_FRCNN= marray_load([h5_FRCNN_dir folder(i).name '/' folder(i).name '_problem.h5'], 'boxes');
    seg_FRCNN= marray_load([h5_FRCNN_dir folder(i).name '/' folder(i).name '_problem.h5'], 'segments');
    VI_L=zeros(size(box_LSDA,1),1);
    VI_F=zeros(size(box_FRCNN,1),1);
    imsize = size(segments{1,1});
    for j=1:size(frame,2)
        % segment of the frame
        cur_gt = segments(j,:);
        % segment of LSDA of the frame
        cur_frame = frame(j);
        box_list = find(box_LSDA(:,6)==cur_frame);
        numDetection = min(size(box_list,1),N_box);
        box_list = box_list(1:numDetection);
        seg_L = seg_LSDA(:,:,box_list);
        % calc VI for each segment 
        for k=1:size(box_list,1)
            cur_seg = seg_L(:,:,k);
            VI_L(box_list(k)) = calcVI(cur_gt, cur_seg, imsize);
        end
        % segment of FRCNN of the frame
        box_list = find(box_FRCNN(:,6)==cur_frame);
        numDetection = min(size(box_list,1),N_box);
        box_list = box_list(1:numDetection);
        seg_F = seg_FRCNN(:,:,box_list);
        % calc VI for each segment
        for k=1:size(box_list,1)
            cur_seg = seg_F(:,:,k);
            VI_F(box_list(k)) = calcVI(cur_gt, cur_seg, imsize);
        end
    end
    VI_F(VI_F==0)=[];
    VI_L(VI_L==0)=[];
    vi_f{i}=VI_F;
    vi_l{i}=VI_L;
end
f=figure(1);clf;
histogram(cell2mat(vi_l),50);hold on;
%figure(2),
histogram(cell2mat(vi_f),50);
set(gca, 'FontSize',  16);
set(ylabel('# segments'), 'FontSize',  16);
set(xlabel('variation of information'), 'FontSize',  16);
legend('Selective search segmentation','Deeplab segmentation');
set(f,'PaperUnits','normalized');
set(f,'PaperPosition', [0 0 1 1]);
set(f,'PaperOrientation','landscape');
print(1,'-dpdf','VI');
save('vi.mat','vi_f','vi_l');