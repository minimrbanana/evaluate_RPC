function rpcFile = save_RPC_txt(txt_file, is_training,IoU)
%% generate RP curves
% input    txt_file       the file name if the txt
% output   rpcFile        the txt file with RPC coordinates

% path
detection_dir = '/home/zhongjie/CodesDown/jointmulticut/joint-multicut/evaluate_RPC/';
%detectionFile = [detection_dir det_file 'cars1S0.0L0.1B0.4.idl'];
detectionFile = [detection_dir txt_file '.idl'];
if is_training
    gt_dir = '/BS/siyu-project/work/MulticutMotionTracking/dataset/Ftrain/Fgt/';
    gtFile = [gt_dir 'FBMS59.idl'];
else
    gt_dir = '/BS/siyu-project/work/MulticutMotionTracking/dataset/FBMS59GT/';
    gtFile = [gt_dir 'FBMS59.idl'];
end
output_dir = [detection_dir 'evaluate/'];
if ~exist(output_dir)
    mkdir(output_dir)
end

rpcFile =  [output_dir txt_file '_' num2str(IoU) '_rpc.txt'];
anaFile =  [output_dir txt_file '_' num2str(IoU) '_ana'];

cmd = ['python "/home/tang/code/Python-Tools/doRPC_new.py" -o "' rpcFile '" -a "' anaFile   '"  "'  gtFile '" "' detectionFile  '" --minOverlap "' num2str(IoU) '"'];
system(cmd,'-echo');

end