clc;clear all;close all;

% FUZZY C MEANS CLUSTERING BY BEIJING NORMAL UNIVERSITY 
%INFORMATION AND SCIENCE TECHNOLOGY COLLEGE @ZHANGJUE
% Images 
filetype='jpg';
sensor='WorldView';
% Which group of pic are processed
MsGroup=strcat('D:\image_fusion\论文程序201703\MS\',sensor);
PanGroup=strcat('D:\image_fusion\论文程序201703\PAN\',sensor);
Result = strcat('D:\image_fusion\论文程序201703\Images\',sensor);
SmlGroup =  strcat('D:\image_fusion\论文程序201703\Results\',sensor,'\SML\');
% Read all files of the specified type
file_ms = dir([MsGroup, '\*.', filetype]);
file_pan = dir([PanGroup, '\*.', filetype]);
file_re = dir([Result, '\*.', filetype]);
file_sml = dir([SmlGroup, '\*.', filetype]);
% Number of images processed at a time
Imgnum = length(file_ms);    

for i=1:1
%READ MS AND PAN IMAGE
I_MS = im2double(imread(strcat(MsGroup, '\',file_ms(i).name))); 
I_PAN = im2double(imread(strcat(PanGroup, '\',file_pan(i).name)));
SML= im2double(imread(strcat(SmlGroup, '\',file_sml(i).name)));
[Row,Column,Band]=size(I_MS);
img=zeros(Row,Column,Band+1);
img(:,:,1:3)=I_MS;
img(:,:,4)=I_PAN;

tic
img=reshape(img,[Row*Column,Band+1]);
ClassNo=5;
% CACULATE ORIGINAL CENTERS USING K-MEANS
    [IDX,seed]=kmeans(img,ClassNo);
    mean1=seed;
    %   Loop 1
    NoOfItr =20;
    Membe_Itrationold=zeros(Row*Column,ClassNo);
    
    m=2;
  [Membe_func] = CalculatingMembershipFunc_new(m,ClassNo,img,seed );
    ChaMemb=zeros(NoOfItr,1);
    for ij=1:NoOfItr    % No of Iteration

        % update cluster centers 
        NewSeed= UpdateCenter( m,ClassNo,Membe_func,img );
      
        % Update Membership based on new center
        Membe_Itrationold=Membe_func;
        [Membe_func] = CalculatingMembershipFunc_new(m, ClassNo,img,NewSeed );

        ChaMemb(ij)= sum(sum((Membe_func-Membe_Itrationold).^2));
            if ij>1 && abs(ChaMemb(ij)-ChaMemb(ij-1))<0.01
                break
            end
             ij=ij+1;
    end
    pal = FinalOutput( I_MS,Membe_func );
    
    %pall=pal*(255/ClassNo);
    
    %figure;imagesc(pall);axis off;
toc


 %save(strcat(Result,'_',num2str(i),'.mat'), 'pal', '-mat')
end
