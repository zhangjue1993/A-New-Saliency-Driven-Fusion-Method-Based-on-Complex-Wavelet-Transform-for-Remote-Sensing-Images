function [Q,std, grad, c,rase]=key_analysefusion(imf,immul,imy)
%求标准偏差，梯度，相关系数，光谱扭曲度，偏差指数
%输入为融合后的图像，多波段图像
%对每个波段进行处理:RGB
%imf=imread(f);融合后的图像f:fusion
%impan=imread(pan);
%immul=imread(mul);
%imy是原参考图像，用于算相关系数
df=double(imf);
dmul=double(immul);
dy=double(imy);
men=mean2(df);

%求标准偏差，标准差越大灰度级分布越分散，目视效果越好
std=std2(df(:));
[mf,nf]=size(dy);
%求融合影像的平均梯度，越大越清晰
q=0;
for i=1:1:mf-1
    for j=1:1:nf-1
        q=q+(sqrt(((df(i,j)-df(i+1,j))^2+(df(i,j)-df(i,j+1))^2)/2));
    end
end
grad=q/((mf-1)*(nf-1));

%求相关系数，反映融合影像同原多光谱影像特征相似程度，即光谱保持性能
%imresize()返回的图像B的长宽是图像A的长宽的m倍，即缩放图像。
%bicubic采用双三次插值算法
%c=corr2(rmul(:),df(:));
c=corr2(dy(:),df(:));

%--求扭曲程度，影像光谱扭曲程度直接反映了多光谱影像的光谱失真度
q1=0;
for i=1:1:mf
    for j=1:1:nf
        q1=q1+abs(df(i,j)-dmul(i,j));
    end
end
warp=q1/(mf*nf);%--求扭曲程度(warping degree )
%--求偏差指数--表示融合影像和低分辨率多光谱影像的偏离程度
q2=0;
a=mean2(dmul(:,:));
for i=1:1:mf
    for j=1:1:nf
        if(dmul(i,j)~=0)
        q2=q2+abs(df(i,j)-dmul(i,j))/dmul(i,j);
        else q2=q2+abs(df(i,j)-dmul(i,j))/a;
        end
    end
end
bias_index = q2 / (mf*nf);%--求偏差指数(bias index)
%{
%求相关系数,这个结果是正确的
q5=0;
q6=0;
q7=0;
mean_df = mean2(df(:));
mean_dmul = mean2(dmul(:));
for i=1:1:mf
    for j=1:1:nf
        q5 = q5 + (df(i, j)-mean_df)*(dmul(i, j)-mean_dmul);
        q6 = q6 + (df(i, j)-mean_df)^2;
        q7 = q7 + (dmul(i, j)-mean_dmul)^2;
    end
end
c = q5/sqrt(q6*q7);
%}


rase=sqrt(sum(sum((imf-imy).^2)/(mf*nf)));



ss=cov(df,dy);
s3=ss(1,2);
s1=ss(1,1);
s2=ss(2,2);
m1=mean2(df);m2=mean2(dy);
Q=s3*2/(s1+s2)*2*m1*m2/(m1^2+m2^2);



