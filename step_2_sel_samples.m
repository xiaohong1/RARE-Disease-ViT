function xg_sel_samples()
clc
global train_path train_label val_path val_label train_no val_no;


title = {'mouth','esophagus','stomach','smallintestine','colon',...,
         'z_line','pylorus','ileocecalvalve','activebleeding','angiectasia', ...,
        'blood','erosion','erythema','hematin','lymphangioectasis', ...,
        'polyp','ulcer'};

sample_no = [2009, 2256, 254994, 1375918, 1878361, ...,
            122, 3183 ,3692 ,5325, 16803,...,
            391715, 39105, 6228, 31773, 17660, ...,
            18415, 11428];
mLabels_1_to_5 = [2994127, 495142, 22501, 1767, 1];
  % with 5_labels=  {'data/Galar_Frames_61_to_70/62/frame_002080.PNG'}

lp = load('img_label_path_1to80.mat')
path = lp.Path;
label = lp.Label;
lls= zeros(1,17);
sz_p_l = [ size(path), size(label)]
train_path = {};
train_label = [];
val_path = {};
val_label = [];

[row,col]=size(label);

train_no = 0;   %mouth
val_no = 0;
%{,
xg_cp(train_no, val_no,path, label,1);  % label-1 (2009) copy all
sz_tr_val_1 = [ train_no, val_no]
pre_tr = train_no;
pre_val = val_no;
xg_cp(train_no,val_no,path, label,2);   % label-2 (2256), copy all
sz_tr_val_2 = [ train_no-pre_tr, val_no-pre_val]
%}
%{,
for ill = 3:5
   label_no = ill 
   pre_tr = train_no;
   pre_val = val_no;  
   xg_find_multiL(label,ill, path);          % label 3(254994), copy 3600
   sz_tr_val_3_5 = [ train_no-pre_tr, val_no-pre_val]
end


for kll = 6:8
    label_no = kll
    pre_tr = train_no;
    pre_val = val_no;
    xg_cp(train_no,val_no,path, label,kll); 
    sz_tr_val_6_8 = [ train_no-pre_tr, val_no-pre_val]%label=6,7,8 
end
%}
for ill =9:17
   label_no = ill
   pre_tr = train_no;
   pre_val = val_no;
   xg_find_multiL(label,ill, path);          % label =9:1
   sz_tr_val_9_17 = [ train_no-pre_tr, val_no-pre_val]
end

%{
train_label(end,:)
train_path{end}
val_label(end,:)
val_path{end}
%}
final_sz = [size(train_path), size(train_label),size(val_label)]
final_train_no_sz = [train_no, val_no]

nonEmptyIdx = find(~cellfun(@isempty,train_path));
train.Path = train_path(nonEmptyIdx)';
train.Label = train_label(nonEmptyIdx,:);
nonEmptyIdx = find(~cellfun(@isempty,val_path));
val.Path = val_path(nonEmptyIdx)';
val.Label = val_label(nonEmptyIdx,:);
save(['train_all.mat'],'-struct','train');
save(['val_all.mat'],'-struct','val');
end % func

function xg_cp(tNo, vNo, path, label, llNo)
   global train_path train_label val_path val_label train_no val_no;

    index = find(label(:,llNo) == 1); %keep mouth
    index(1:2);
    sz_idx = max(size(index));
    llNo;
    to_train_no = round(0.8*sz_idx);
    to_val_no = sz_idx - to_train_no;
    
    for i=1: to_train_no
       train_path{i+tNo} = path{index(i)};
       train_label(i+tNo,1:17) = label(index(i),:);
    end


    train_no = to_train_no + tNo;

    for i=1: to_val_no
       val_path{i+vNo} = path{index(i)};
       val_label(i+vNo,1:17) = label(index(i),:);
    end
    val_no = to_val_no + vNo;
    
end %xg_cp

function xg_cp_m(tNo, vNo, path, label, llNo, inc)
   global train_path train_label val_path val_label train_no val_no;

    sm = sum(label(:,1:17));
    index = find(label(:,llNo) == 1); %keep mouth
    index(1:2);
    sz_idx = max(size(index));
    train_no = round(0.8*sz_idx);
    val_no = sz_idx - train_no;
    
    for i=1: inc: train_no
       train_path{i+tNo} = path{index(i)};
       train_label(i+tNo,1:17) = label(index(i),:);
    end
    train_no = train_no + tNo;

    for i=1: inc: val_no
       val_path{i+vNo} = path{index(i)};
       val_label(i+vNo,1:17) = label(index(i),:);
    end
    val_no = val_no + vNo;
    
end %xg_cp_m

function xg_find_multiL(label,lN, path)
 global train_path train_label val_path val_label train_no val_no;
 
    total_1_label =4500;

    idx = find(label(:,lN)==1);
    idx_lN = size(idx);
    first_sample_path_is = path{idx(1)};
    first_sample_label_is = label(idx(1),:)
    l2 = label(idx,:);     %all sammples with the current label
    p2 = path(idx);
    l2_1to5_ll = l2(1:5,:);
    p2_1to5_path = p2(1:5);
    sz_l2_p2 = [size(l2),size(p2)];
    sm = sum(l2,2);    %multiple lable calculations
    idx1 = find(sm==1);
    idx2 = find(sm==2);
    idx3 = find(sm==3);
    idx4 = find(sm==4);
    idx5 = find(sm==5);
    n1 = size(idx1,1);
    n2 = size(idx2,1);
    n3 = size(idx3,1);
    n4 = size(idx4,1);
    n5 = size(idx5,1);
    sz_label_12345 = [n1,n2,n3,n4,n5];
    inc1=1;
    inc2=1;
    inc3=1;
    inc4=1;
    inc5=1;

   % for 5 labels
    tNo = train_no
    for i =1: n5
       train_path{i+tNo} = p2{idx5(i)};
       train_label(i+tNo,1:17) = l2(idx5(i),:);
    end
    train_no = train_no + n5

    if n1==0
        n23 = total_1_label - n4-n5;
        n02 = round(n23/2);
        n03 = n23 - n02;
        inc2 = round(n2/n02);
        if n2 < 1000
           inc2 =inc2 - 3;
        end
        if n2 < 500
            inc2 = inc2 -2;
        end
        inc3 = round(n3/n03);
        inc2 = max(inc2,1);
        inc3 = max(inc3,1);
    end
    if n1 ~=0 & n3 >3000
        n03 = 3000;     % keep for training
        inc3 = round(n3/n03);
        inc3 = max(inc3,1);
    end
    if n1 ~=0 & n3 <=3000
        n03 = n3;
        inc3 = 1;
    end
    if n1 ~= 0 & n2 ~= 0
        n12 = total_1_label - n4-n5-n03;
        n01 = round(n12/2);
        n02 = n12 - n01;
        inc1 = round(n1/n01);
        inc2 = round(n2/n02);
        inc1 = max(inc1,1);
        inc2 = max(inc2,1);
    end
    if (n1==0 & (n3+n4+n5)<1000)
        dif2 = total_1_label -n4-n5-n3;
        inc2 = round(n2/dif2);
         inc2 = max(inc2,1);
    end
     % 4-labels
    tNo = train_no; 
    vNo = val_no;
 %   sample_4_ll = l2(idx4(1:5),:)
  % disp('### 4-label ###')
    %xg_cp_ll_4321(tNo, vNo,idx4, inc4, path, label);
     xg_cp_ll_4321(tNo, vNo,idx4, inc4, p2, l2);
     % 3-labels
    %   disp('### 3-label ###')
    tNo = train_no;
    vNo = val_no;
 %    sample_3_ll = l2(idx3(1:5),:)
    xg_cp_ll_4321(tNo, vNo,idx3, inc3, p2, l2);
     % 2-labels
     %  disp('### 2-label ###')
    tNo = train_no;
    vNo = val_no;
  %    sample_2_ll = l2(idx2(1:5),:)
    idx_inc_n2_n1 = [size(idx2),inc2, n2,n1]
    xg_cp_ll_4321(tNo, vNo,idx2, inc2, p2, l2);
     % 1-labels
   %  disp('### 1-label ###')
    tNo = train_no
    vNo = val_no
   % sample_1_ll = l2(idx1(1:5),:)
    xg_cp_ll_4321(tNo, vNo,idx1, inc1, p2, l2);


end % xg_find_multiL

function xg_cp_ll_4321(tNo, vNo,idx, inc, path, label)
 global train_path train_label val_path val_label train_no val_no;

    idx_inc_tNo_vNo = [size(idx),inc, tNo, vNo];
 %   sample_4_ll = label(idx(1:4), :)
    sz_idx = size(idx);
    to_tr_no = round(0.8*sz_idx(1,1));
    to_val_no = sz_idx(1,1) - to_tr_no;
    
    count=0;
    for i=1: inc: to_tr_no
        count = count + 1;
       train_path{i+tNo} = path{idx(i)};
       train_label(i+tNo,1:17) = label(idx(i),:);
    end
    train_no = train_no + count

    count = 0;
    for i=1: inc: to_val_no
        count = count + 1;
       val_path{i+vNo} = path{idx(i)};
       val_label(i+vNo,1:17) = label(idx(i),:);
    end
    val_no = val_no + count;

   %last_val_ll = val_label(end,:)
  % last_val_path = val_path{end}
   %last_tr_ll = val_label(end,:)
   %last_tr_path = val_path{end}

    overall_train_val_no = [train_no, val_no];
end % xg_cp_ll_4321