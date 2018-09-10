function LE=LocalEntropy(I_PAN,window)

Window=5;
[M N]=size(I_PAN);

L=floor(Window/2);
ss=zeros(M,N);
I_PAN_EX=zeros(M+2*L,N+2*L);
I_PAN_EX(L+1:M+L,L+1:N+L)=I_PAN;

temp=0;
for i=L+1:M+L
    for j=L+1:N+L
  temp=sum(sum(I_PAN_EX(i-L:i+L,j-L:j+L).^2))/(sum(sum(I_PAN_EX(i-L:i+L,j-L:j+L)))).^2  ;
   ss(i,j)=temp;
    end
end
D=(ss(L+1:M+L,L+1:N+L)>(max(max(ss)))/200);
LE=ss(L+1:M+L,L+1:N+L).*D;
end
