function rpcFile = save_RPC_txt_train(txt_file)
%% generate RP curves
% input    txt_file       the file name of the txt
% output   rpcFile        the txt file with RPC coordinates

% path
detection_dir = '/BS/joint-multicut-2/work/FBMS-fasterRCNN/RPC-plot/Training/';
%detectionFile = [detection_dir det_file 'cars1S0.0L0.1B0.4.idl'];
detectionFile = [detection_dir 'FBMS' txt_file '.idl'];

gt_dir = '/BS/siyu-project/work/MulticutMotionTracking/dataset/Ftrain/Fgt/';
%gtFile = [gt_dir det_file(1:end-1) '.idl'];
gtFile = [gt_dir 'FBMS59.idl'];

output_dir = [detection_dir 'evaluate/'];
if ~exist(output_dir)
    mkdir(output_dir)
end

rpcFile =  [output_dir txt_file '_rpc.txt'];
anaFile =  [output_dir txt_file '_ana'];

cmd = ['python "/home/tang/code/Python-Tools/doRPC_new.py" -o "' rpcFile '" -a "' anaFile   '"  "'  gtFile '" "' detectionFile   '"'];
system(cmd,'-echo');

end