function xg_gen_CSV_all()

%title = readtable('../labels17_names.txt');
%titles = [7,8,9,10,11,2,3,5,14,18,15,17,16,23,26,13,12];

title = {'mouth','esophagus','stomach','smallintestine','colon',...,
    'z_line','pylorus','ileocecalvalve','activebleeding', ...,
'angiectasia','blood','erosion','erythema','hematin',...,
'lymphangioectasis','polyp','ulcer'};
d0 = 0; %0 for the very frist patch 
data_1to10 = load('img_label_path_1to70.mat')
all_label = data_1to10.Label;
all_path = data_1to10.Path;
all_path = all_path';
imgFld = 'data/Galar_Frames_71_to_80/';
for videoNo = 71:80
    vNo = videoNo

    file = ['Galar_labels_and_metadata/labels/',num2str(videoNo),'.csv']  
    data = readtable(file);
    dt_sz= size(data)
    newCSV = zeros(dt_sz(1),17);    %17 catgory 
    headers = data.Properties.VariableNames;
    headers = lower(headers);
    headers = strrep(headers,' ','');
    headers = strrep(headers,'-','_');
    for i= 1:17
       t1 = title{i};
       t1 = strrep(t1,' ','');
       idx = find(strcmp(t1, headers));
      newCSV(:,i) = data{:,idx};
     % sz_tmp = size(tmp)
    end
   
    imgPath = {dt_sz(1,1)}; % creating img path list file
    for j=1: dt_sz(1,1)   %row #
        frameNo = data{j,'frame'};
        imgPath{j} = [imgFld,num2str(videoNo),...,
            '/','frame_',num2str(frameNo,'%06d'),'.PNG'];
    end

    all_label = [all_label;newCSV];
    if videoNo ==1
        all_path = {all_path;imgPath}
    else
        all_path = [all_path,imgPath];  
    end %if

    sz_path_lable=[size(all_path), size(all_label)]
    if max(size(all_path))==2
     all_path =all_path{2};
    end
%clear data imgPath newCSV
end %videoNo

 sz_all_path = size(all_path)
 sz_all_label = size(all_label)

img.Path = all_path';
img.Label = all_label;
save(['img_label_path_1to80.mat'],'-struct','img');
test = load('img_label_path_1to80.mat')


%save('imgPath.mat',"imgPath");
%save('imgLabels.mat','newCSV');

%disp('CSV Headers:');
%disp(headers);

end %xg_gen_CSV_all
