% Dual tree complex wavelet transform (DT-CWT) based image fusion demo
% By Zhang Jue from Beijing Normal University
% DT-CWT software used in this fusion algorithm is from VPS Naidu, MSDF Lab, June 2011
clear all; close all;clc;

[Faf,Fsf] = FSfarras; % First stage filters
[af,sf] = dualfilt1;  % Second stage filters


% Images 
filetype='jpg';
sensor='SPOT5';

K=3;%SPOT5
%K=4;%Geoeye-1
SGroup = strcat('D:\image_fusion\论文程序201703\Results\',sensor,'\Saliency\');
% Which group of pic are processed
Result = strcat('D:\image_fusion\论文程序201703\Results\',sensor,'_fused\MAX');
RefGroup = strcat('D:\image_fusion\论文程序201703\Images\',sensor);
MsGroup=strcat('D:\image_fusion\论文程序201703\MS\',sensor);
PanGroup=strcat('D:\image_fusion\论文程序201703\PAN\',sensor);


% Read all files of the specified type
file_ms = dir([MsGroup, '\*.', filetype]);
file_pan = dir([PanGroup, '\*.', filetype]); 
file_salm = dir([SGroup, '\*.', filetype]); 
file_ref = dir([RefGroup, '\*.', filetype]); 
% Number of images processed at a time
Imgnum = length(file_ms);                         
tic
for i=1:Imgnum
I_MS = im2double(imread(strcat(MsGroup, '\',file_ms(i).name))); 
im1 = I_MS;IHS= rgb2hsi(I_MS) ;
I_PAN = im2double(imread(strcat(PanGroup, '\',file_pan(i).name)));
Ref = im2double(imread(strcat(RefGroup, '\',file_ref(i).name)));
SalM = im2double(imread(strcat(SGroup, '\',file_salm(i).name)));

%figure; subplot(221);imshow(I_MS); subplot(222); imshow(I_PAN,[]);subplot(223); imshow(SalM,[]);subplot(224); imshow(Ref,[]);
[M, N] = size(I_PAN);INT=IHS(:,:,3);
I_PAN_HM=HistogramMatch(I_PAN,INT);
% BW = edge(I_PAN_HM,'canny');
% S(:,:,1) = guidedfilter(I_PAN,I_MS(:,:,1),7,0.01);
% S(:,:,2) = guidedfilter(I_PAN,I_MS(:,:,2),7,0.01);
% S(:,:,3) = guidedfilter(I_PAN,I_MS(:,:,3),7,0.01);
% 
% figure; imshow(S);
%[I_PAN_HM,~]=GIHS(I_MS,I_PAN);
% Image decomposition
w1 = cplxdual2D(INT,K,Faf,af);
w2 = cplxdual2D(I_PAN_HM,K,Faf,af);

% Image fusion process start here
for j=1:K % number of stages
    for p=1:2 %1:real part & 2: imaginary part
        for d1=1:2 % orientations
            for d2=1:3
                x = w1{j}{p}{d1}{d2};
                z = w2{j}{p}{d1}{d2};
                SM_H = mat2gray(imresize(SalM,size(x))); 
%                 SI_H = (SM_H) >= graythresh(SM_H); 
                 D  = (abs(z)-abs(x)) >= 0; 
%                 Mask=D.*SI_H;
                %sopt5:
                wf{j}{p}{d1}{d2} =SM_H.*z + (1-SM_H).*(0.5*z+0.5*x); % SPOT5 image fusion
               % wf{j}{p}{d1}{d2} = D.*z+(~D).*x;
                %wf{j}{p}{d1}{d2} = 1/2.*z+(1/2).*x;
               %wf{j}{p}{d1}{d2} = SM_H.*z + (1-SM_H).*(0.69*z+0.31*x); % Geoeye image fusion

            end
        end
    end
end


for m=1:2 % lowpass subbands
    for n=1:2
        % % fusion of lopass subbands
%         SM_L = mat2gray(imresize(SalM,size(w1{K+1}{m}{n}))); 
%         SI_L = (SM_L) >= graythresh(SM_H); 
         x = w1{K+1}{m}{n};
         z = w2{K+1}{m}{n};
            SM_L = mat2gray(imresize(SalM,size(x))); 
%         D  = (abs(z)-abs(x)) >= 0; 
%         Mask=D.*SI_L;
       % wf{K+1}{m}{n} =  x; % image fusion; % fusion of lowpass subbands
    wf{K+1}{m}{n} = x;
    end
end

% Fused image
imf = icplxdual2D(wf,K,Fsf,sf);
I=zeros(M,N,3);
I(:,:,1)=IHS(:,:,1);
I(:,:,2)=IHS(:,:,2);
I(:,:,3)=imf;

I_F=hsi2rgb(I);

%imwrite(I_F,strcat(Result,'\F_',file_ms(i).name));

 [Q,~,~,CC,~,EGRAS] = analyse_fusion(double(I_F),double(I_MS),double(Ref),double(I_PAN));
 [D_lambda,D_S,QNR_index,SAM_index,sCC] = indexes_evaluation_FS(double(I_F),double(Ref),double(I_PAN),1,1,double(I_MS),'none','none',1);
 fprintf('Q%8.5f  CC%8.5f    D_lambda%8.5f EGRAS%8.5f\n',Q,CC,D_lambda,EGRAS);
 fprintf('D_S%8.5f  QNR%8.5f  SAM%8.5f sCC%8.5f\n',D_S, QNR_index,SAM_index,sCC);

end
