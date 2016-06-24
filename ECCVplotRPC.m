%% script for RPC plot
saveidl=0;
if saveidl
    %% fasterRCNN no NMS, score 0.2
    Min_score=0.2;Nms_box=1;
    det2idl_fasterRCNN_train(Min_score, Nms_box);
    det2idl_fasterRCNN_test(Min_score, Nms_box);

    %% LSDA no NMS, score 0.2 color only(LC)
    Min_score=0.2;Nms_box=1;withFlow=0;
    det2idl_LSDA_train(Min_score, Nms_box, withFlow);
    det2idl_LSDA_test(Min_score, Nms_box, withFlow);

    %% LSDA no NMS, score 0.2 with Optical flow
    Min_score=0.2;Nms_box=1;withFlow=1;
    det2idl_LSDA_train(Min_score, Nms_box, withFlow);
    det2idl_LSDA_test(Min_score, Nms_box, withFlow);

    %% fasterRCNN  NMS 0.7, score 0.2
    Min_score=0.2;Nms_box=0.7;
    det2idl_fasterRCNN_train(Min_score, Nms_box);
    det2idl_fasterRCNN_test(Min_score, Nms_box);

    %% LSDA no NMS, score 0.2 color only(LC)
    Min_score=0.2;Nms_box=0.7;withFlow=0;
    det2idl_LSDA_train(Min_score, Nms_box, withFlow);
    det2idl_LSDA_test(Min_score, Nms_box, withFlow);

    %% LSDA no NMS, score 0.2 with Optical flow
    Min_score=0.2;Nms_box=0.7;withFlow=1;
    det2idl_LSDA_train(Min_score, Nms_box, withFlow);
    det2idl_LSDA_test(Min_score, Nms_box, withFlow);
end
%% plot
fid = fopen('fasterRCNN_0.2_0.7_test_rpc.txt');
data = textscan(fid, '%f%f%f%f');
fclose(fid);
P = data{1};
R = data{2};
h = figure('visible','on');
plot(1-P',R');
hold on;
fid = fopen('LSDA_0.2_0.7_test_rpc.txt');
data = textscan(fid, '%f%f%f%f');
fclose(fid);
P = data{1};
R = data{2};
plot(1-P',R');
hold on;
fid = fopen('LSDA_0.2_0.7_Flow_test_rpc.txt');
data = textscan(fid, '%f%f%f%f');
fclose(fid);
P = data{1};
R = data{2};
plot(1-P',R');
hold on;
%plot(1-P(r)',R(r)','*');
%text(1-P(r)',R(r)'-0.05,num2str(R(r)));
xlabel('1-Precision');
ylabel('Recall');
axis([0 1 0 1]);
title('Testset-S0.2-N0.7-rpc');
legend('fasterRCNN','LSDA','LSDA+OF');
saveas(h,'Testset-S0.2-N0.7-rpc.jpg');











