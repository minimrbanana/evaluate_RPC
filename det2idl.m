function det2idl( annopath, fid, det_all)


% list_det = dir([filepath  '*_det*.mat']);


fprintf(fid, '"%s": ', annopath);

for b=1:size(det_all,1)
    fprintf(fid, '(%.3f, %.3f, %.3f, %.3f)', det_all(b,1), det_all(b,2), det_all(b,3), det_all(b,4));
    fprintf(fid, ':%f', det_all(b,5));
    %             if haveCompIdx; fprintf(fid, ':%f', detections(i).comp_idx(b)); end;
    %             if haveorientation; fprintf(fid, ':%f', detections(i).comp_idx(b)); end;
    fprintf(fid, ', ');
end
fseek(fid, -2, 'cof');
fprintf(fid, ';\n');

end
