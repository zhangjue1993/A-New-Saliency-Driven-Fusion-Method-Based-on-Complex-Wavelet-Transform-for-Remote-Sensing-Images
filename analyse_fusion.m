function[Q ,std, grad, co, rase,ergas]=analyse_fusion(c1,c,y,im2)

[Q_r,std_r,grad_r,co_r,rase_r]=key_analysefusion(c1(:,:,1),c(:,:,1),y(:,:,1));%R
[Q_g,std_g,grad_g,co_g,rase_g]=key_analysefusion(c1(:,:,2),c(:,:,2),y(:,:,2));%G
[Q_b,std_b,grad_b,co_b,rase_b]=key_analysefusion(c1(:,:,3),c(:,:,3),y(:,:,3));%B
Q=(Q_r+Q_g+Q_b)/3;
std = (std_r + std_g + std_b)/3;
grad = (grad_r + grad_g + grad_b)/3;
co = (co_r + co_g + co_b)/3;
rase=(rase_r+rase_g+rase_g)/3;
ergas=100*0.5/2*sqrt(((rase_r/mean2(y(:,:,1)))).^2+(rase_g/mean2(y(:,:,1))).^2+(rase_b/mean2(y(:,:,1))).^2/3);
QS=0;QP=0;temp=0;
for i=1:3
    for j=1:3
        if i~=j
        df=double(c1(:,:,i)); dy=double(c1(:,:,j));
       ss=cov(df,dy);
    s3=ss(1,2);
    s1=ss(1,1);
    s2=ss(2,2);
        m1=mean2(df); m2=mean2(dy);
        Q1=s3*2/(s1+s2)*2*m1*m2/(m1^2+m2^2);
        df=double(c(:,:,i)); dy=double(c(:,:,j));
       ss=cov(df,dy);
        s3=ss(1,2);
        s1=ss(1,1);
        s2=ss(2,2);
    m1=mean2(df); m2=mean2(dy);
        Q2=s3*2/(s1+s2)*2*m1*m2/(m1^2+m2^2);
        temp=abs(Q1-Q2);
        
        end
        QS=QS+temp;
    end
end
QS=QS/12;
temp=0;
for i=1:3
        df=double(c1(:,:,i)); dy=double(im2);
        ss=cov(df,dy);
         s3=ss(1,2);
          s1=ss(1,1);
        s2=ss(2,2);
        m1=mean2(df); m2=mean2(dy);
        Q1=s3*2/(s1+s2)*2*m1*m2/(m1^2+m2^2);
        temp=abs(Q1-Q2); 
        QP=QP+temp;
end
QP=QP/3;



