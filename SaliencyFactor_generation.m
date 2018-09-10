clc;close all;clear;
filetype='jpg';
sensor='Geoeye-1';
ClusterGroup = strcat('D:\image_fusion\论文程序201703\Results\',sensor,'\mat_new');
% Which group of pic are processed
Result = strcat('D:\image_fusion\论文程序201703\Results\',sensor,'_fused');
MsGroup=strcat('D:\image_fusion\论文程序201703\MS\',sensor);
PanGroup=strcat('D:\image_fusion\论文程序201703\PAN\',sensor);
SGroup = strcat('D:\image_fusion\论文程序201703\Results\',sensor);
% Read all files of the specified type
file_ms = dir([MsGroup, '\*.', filetype]);
file_pan = dir([PanGroup, '\*.', filetype]); 

% Number of images processed at a time
Imgnum = length(file_ms);   

%RGB2LAB
tic
for j=1:Imgnum
    
I_MS = im2double(imread(strcat(MsGroup, '\',file_ms(j).name))); 
I_PAN = im2double(imread(strcat(PanGroup, '\',file_pan(j).name)));  

[M, N, k] = size(I_MS);sigma=0.4;
ClusterAll = load(strcat(ClusterGroup,'\',sensor,'_',num2str(j),'.mat'));
Cluster = ClusterAll.pal;
img_Rgb=zeros(M*N,k+1);
img_Rgb(:,1:k)=reshape(I_MS,M*N,k);
img_Rgb(:,k+1)=reshape(I_PAN,M*N,1);

K = max(max(Cluster));
Nlabel=Cluster;
nlabel = reshape(Cluster,M*N,1);
%Compute The Color Similarity
ti = zeros(1,k+1);tj = zeros(1,k+1);
 Color_AVR = zeros(K,k+1);
 for i = 1:K
     si = find (nlabel==i);
     Color_AVR(i,:) = mean(img_Rgb(si,:));   
 end
 
 Color_Dis=squareform(pdist(Color_AVR,'euclidean'));
 Color_Sim=exp(-Color_Dis./sigma^2);
 Pixel_Cen=regionprops(Nlabel,'Centroid');
 Pixel_Num=regionprops(Nlabel,'Area');
 temp1=[]; temp2=[];
 for i=1:K
     temp1=[temp1 Pixel_Num(i).Area];
     temp2=[temp2;Pixel_Cen(i).Centroid];
 end
 
for i=1:K
    img_Lab(find(nlabel==i),:)=repmat(Color_AVR(i,:),temp1(i),1);
end

 img=reshape(img_Lab,M,N,k+1);
 Pixel_Num_Squre=repmat(temp1,K,1);
 temp2=reshape(temp2,2,K);
 Pixel_CX=repmat(temp2(1,:),K,1); Pixel_CY=repmat(temp2(2,:),K,1);
 ux=sum(Pixel_Num_Squre.*Color_Sim.*Pixel_CX,2)./sum(Pixel_Num_Squre.*Color_Sim,2);
 uy=sum(Pixel_Num_Squre.*Color_Sim.*Pixel_CY,2)./sum(Pixel_Num_Squre.*Color_Sim,2);
 u=zeros(2,K);u(1,:)=ux;u(2,:)=uy;
%cc=sum(Pixel_Num_Squre.*Color_Sim.*sum((temp2-u)).^2,2)./sum(Pixel_Num_Squre.*Color_Sim,2);
 cc=sum(Pixel_Num_Squre.*Color_Sim,2);

for i=1:K
    Ssc(find(nlabel==i))=1-cc(i)/max(cc);
end
ssc=Ssc./max(max(Ssc));
 ssc=reshape(ssc,M,N);
% figure;imshow(ssc,[]);
% imwrite(ssc,strcat(SGroup, '\S',file_ms(j).name));

end
toc














