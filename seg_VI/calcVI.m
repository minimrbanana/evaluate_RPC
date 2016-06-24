function vi = calcVI(gt,seg,imsize)
% calculate the VI of current segmentation and ground truth
n1 = size(gt,2)+1;
n2 = 2;
N = imsize(1)*imsize(2);
% make sure size are the same
if imsize(1)~=size(seg,1)||imsize(2)~=size(seg,2)
    seg = imresize(seg,[imsize(1),imsize(2)]);
end
p = zeros(n1,1);
q = zeros(n2,1);
r = zeros(n1,n2);
v = zeros(n1,n2);
% calc q
q(1) = sum(sum(seg))/N;
q(2) = 1-q(1);
% calc p
BG = ones(size(seg));
for i=1:n1-1
    cur_gt = gt{1,i};
    if isempty(cur_gt)
        cur_gt=zeros(size(seg));
    end
    p(i) = sum(sum(cur_gt))/N;
    for j=1:2
        if j==2
            cal_seg = ~seg;
        else
            cal_seg = seg;
        end
        r(i,j)=sum(sum(cur_gt&cal_seg))/N;
        if r(i,j)==0
            v(i,j)=0;
        else
            v(i,j)=-r(i,j)*(log(r(i,j)/p(i))+log(r(i,j)/q(j)));
        end
    end
    BG = BG-cur_gt;
end
i=n1;
cur_gt = BG;
p(i) = sum(sum(cur_gt))/N;
for j=1:2
    if j==2
        cal_seg = ~seg;
    else
        cal_seg = seg;
    end
    r(i,j)=sum(sum(cur_gt&cal_seg))/N;
    if r(i,j)==0
        v(i,j)=0;
    else
        v(i,j)=-r(i,j)*(log(r(i,j)/p(i))+log(r(i,j)/q(j)));
    end
end

vi = sum(sum(v));









