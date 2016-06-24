%% plot recall w.r.t number of boxes
pause;
%% trainingset
% fasterRCNN
Min_score=0.2;Nms_box=1; 
is_training=1;
recall1=zeros(1,8);
recall2=zeros(1,8);
recall3=zeros(1,8);
for i=1:8
N_box=i*5-4;
% generate idl file of the RP curve
det2idl_fasterRCNN_train(Min_score, Nms_box, N_box);
% generate txt file of the RP curve
txt_file = sprintf('fasterRCNN_%.1f_%.1f_%d_train',Min_score, Nms_box,N_box);
rpcFile = save_RPC_txt(txt_file,is_training);
% find recall
fid = fopen(rpcFile);
data = textscan(fid, '%f%f%f%f');
fclose(fid);
R = data{2};
recall1(i)=R(end);
%LSDA without OF
withFlow=0;
det2idl_LSDA_train(Min_score, Nms_box, withFlow, N_box);
% generate txt file of the RP curve
txt_file = sprintf('LSDA_%.1f_%.1f_%d_train',Min_score, Nms_box,N_box);
rpcFile = save_RPC_txt(txt_file,is_training);
% find recall
fid = fopen(rpcFile);
data = textscan(fid, '%f%f%f%f');
fclose(fid);
R = data{2};
recall2(i)=R(end);
%LSDA with OF
withFlow=1;
det2idl_LSDA_train(Min_score, Nms_box, withFlow, N_box);
% generate txt file of the RP curve
txt_file = sprintf('LSDA_%.1f_%.1f_%d_Flow_train',Min_score, Nms_box,N_box);
rpcFile = save_RPC_txt(txt_file,is_training);
% find recall
fid = fopen(rpcFile);
data = textscan(fid, '%f%f%f%f');
fclose(fid);
R = data{2};
recall3(i)=R(end);
end

%% plot
i=1:8;
NumberOfBox = i*5-4;
figure(1),
plot(NumberOfBox,recall1);
hold on;
plot(NumberOfBox,recall2);
hold on;
plot(NumberOfBox,recall3);
hold on;
legend('fasterRCNN','LSDA','LSDA+OF');
axis([0 40 0 1]);
save('recall_Nbox_0.5_train.mat','NumberOfBox','recall1','recall2','recall3');
%% testset
% fasterRCNN
Min_score=0.2;Nms_box=1; 
is_training=0;
recall1=zeros(1,8);
recall2=zeros(1,8);
recall3=zeros(1,8);
for i=1:8
N_box=i*5-4;
% generate idl file of the RP curve
det2idl_fasterRCNN_test(Min_score, Nms_box, N_box);
% generate txt file of the RP curve
txt_file = sprintf('fasterRCNN_%.1f_%.1f_%d_test',Min_score, Nms_box,N_box);
rpcFile = save_RPC_txt(txt_file,is_training);
% find recall
fid = fopen(rpcFile);
data = textscan(fid, '%f%f%f%f');
fclose(fid);
R = data{2};
recall1(i)=R(end);
%LSDA without OF
withFlow=0;
det2idl_LSDA_test(Min_score, Nms_box, withFlow, N_box);
% generate txt file of the RP curve
txt_file = sprintf('LSDA_%.1f_%.1f_%d_test',Min_score, Nms_box,N_box);
rpcFile = save_RPC_txt(txt_file,is_training);
% find recall
fid = fopen(rpcFile);
data = textscan(fid, '%f%f%f%f');
fclose(fid);
R = data{2};
recall2(i)=R(end);
%LSDA with OF
withFlow=1;
det2idl_LSDA_test(Min_score, Nms_box, withFlow, N_box);
% generate txt file of the RP curve
txt_file = sprintf('LSDA_%.1f_%.1f_%d_Flow_test',Min_score, Nms_box,N_box);
rpcFile = save_RPC_txt(txt_file,is_training);
% find recall
fid = fopen(rpcFile);
data = textscan(fid, '%f%f%f%f');
fclose(fid);
R = data{2};
recall3(i)=R(end);
end


%% plot
i=1:8;
NumberOfBox = i*5-4;
figure(2),
plot(NumberOfBox,recall1);
hold on;
plot(NumberOfBox,recall2);
hold on;
plot(NumberOfBox,recall3);
hold on;
legend('fasterRCNN','LSDA','LSDA+OF');
axis([0 40 0 1]);
save('recall_Nbox_0.5_test.mat','NumberOfBox','recall1','recall2','recall3');


%% plot with different IoU
%% trainingset
% fasterRCNN
Min_score=0.2;Nms_box=1; 
is_training=1;
recall1=zeros(3,8);
recall2=zeros(3,8);
recall3=zeros(3,8);
for IoU = 0.5:0.2:0.9
for i=1:8
N_box=i*5-4;
% generate txt file of the RP curve
txt_file = sprintf('fasterRCNN_%.1f_%.1f_%d_train',Min_score, Nms_box,N_box);
rpcFile = save_RPC_txt(txt_file,is_training,IoU);
% find recall
fid = fopen(rpcFile);
data = textscan(fid, '%f%f%f%f');
fclose(fid);
R = data{2};
recall1(IoU*5-1.5,i)=R(end);
%LSDA without OF
withFlow=0;
% generate txt file of the RP curve
txt_file = sprintf('LSDA_%.1f_%.1f_%d_train',Min_score, Nms_box,N_box);
rpcFile = save_RPC_txt(txt_file,is_training,IoU);
% find recall
fid = fopen(rpcFile);
data = textscan(fid, '%f%f%f%f');
fclose(fid);
R = data{2};
recall2(IoU*5-1.5,i)=R(end);
%LSDA with OF
withFlow=1;
% generate txt file of the RP curve
txt_file = sprintf('LSDA_%.1f_%.1f_%d_Flow_train',Min_score, Nms_box,N_box);
rpcFile = save_RPC_txt(txt_file,is_training,IoU);
% find recall
fid = fopen(rpcFile);
data = textscan(fid, '%f%f%f%f');
fclose(fid);
R = data{2};
recall3(IoU*5-1.5,i)=R(end);
end
end


i=1:8;
NumberOfBox = i*5-4;
lw = 3;
f=figure(3);clf,
plot(NumberOfBox,recall1(1,:),'b','LineWidth',lw);
hold on;
plot(NumberOfBox,recall2(1,:),'r','LineWidth',lw);
hold on;
plot(NumberOfBox,recall3(1,:),'g','LineWidth',lw);
hold on;
plot(NumberOfBox,recall1(2,:),':b','LineWidth',lw);
hold on;
plot(NumberOfBox,recall2(2,:),':r','LineWidth',lw);
hold on;
plot(NumberOfBox,recall3(2,:),':g','LineWidth',lw);
hold on;
plot(NumberOfBox,recall1(3,:),'--b','LineWidth',lw);
hold on;
plot(NumberOfBox,recall2(3,:),'--r','LineWidth',lw);
hold on;
plot(NumberOfBox,recall3(3,:),'--g','LineWidth',lw);
hold on;
set(gca, 'FontSize',  14);
legend({'Faster R-CNN, IoU=0.5','LSDA, IoU=0.5','LSDA+OF, IoU=0.5','Faster R-CNN, IoU=0.7','LSDA, IoU=0.7','LSDA+OF, IoU=0.7','Faster R-CNN, IoU=0.9','LSDA, IoU=0.9','LSDA+OF, IoU=0.9'},'FontSize', 14, 'Location','northwest');
legend({'Faster R-CNN','LSDA','LSDA+OF'},'FontSize', 14, 'Location','northwest');
axis([0 40 0 1]);
xlabel('Number of Detections');
ylabel('Recall');
set(ylabel('recall'), 'FontSize',  18);
set(xlabel('# detections'), 'FontSize',  18);
set(f,'PaperUnits','normalized');
set(f,'PaperPosition', [0 0 1 1]);
set(f,'PaperOrientation','landscape');
print(f,'-dpdf','rpc_number_box');

%save('recall_Nbox_0.579_train.mat','NumberOfBox','recall1','recall2','recall3');






