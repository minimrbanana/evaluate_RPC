%% script_plot_PRC with various parameters for FBMS
% score, label_thr, bbox_thr
for Min_score = 0.0%:0.4:1
for Nms_box = 1%:0.2:0.4
fprintf('outer %f, inner %f processing\n',Min_score,Nms_box);
% generate idl file with three parameters
det2idl_fasterRCNN_test(Min_score, Nms_box);
% generate txt file of the RP curve
txt_file = sprintf('S%.1fB%.1f',Min_score, Nms_box);
rpcFile = save_RPC_txt(txt_file);

% plot the RP curve
textFile = ['/BS/joint-multicut-2/work/FBMS-fasterRCNN/RPC-plot/Test/evaluate/' txt_file '_rpc.txt'];
fid = fopen(textFile);
data = textscan(fid, '%f%f%f%f');
fclose(fid);

P = data{1};
R = data{2};
%D = abs(P - R);
%[r,~] = find(D==min(min(D)));
%r=r(end);
h = figure('visible','off');
plot(1-P',R');
%hold on;
%plot(1-P(r)',R(r)','*');
%text(1-P(r)',R(r)'-0.05,num2str(R(r)));
xlabel('1-Precision');
ylabel('Recall');
axis([0 1 0 1]);
title(txt_file);
figureFile = ['/BS/joint-multicut-2/work/FBMS-fasterRCNN/RPC-plot/Test/' txt_file '_rpc.jpg'];
saveas(h,figureFile);
clf;
end
end