function [ Membe_func ] = MembershipNew( ClassNo,img,seed,m )
%UNTITLED Summary of this function goes here
%   Detailed explanatiU
[Row,Column]=size(img);
Xim=zeros(ClassNo,Row,Column);
XiminCk=zeros(ClassNo,Row,Column,Bands);
Xim2=zeros(Row,Column);
for i=1:ClassNo
    for j=1:Bands
    XiminCk(i,:,:,j)=(InputImage(:,:,j)-seed(j,i)).^2;
    end
    Xim=squeeze(sum(XiminCk,4));
    
end




for i=1:Row
    for j=1:Column
        for k=1:ClassNo
            Sumition=0;
            for l=1:ClassNo
            Sumition=Sumition+Xim(k,i,j)/Xim(l,i,j);
            end
            Membe_func(i,j,k)=1/(Sumition^(1/(m-1)));
        end
        
    end
end


end




function [ Membe_func ] = member( ClassNo,InputImage,seed,m )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[Row,Column,Bands]=size(InputImage);
InputImageTemp=zeros(Bands,1);
seedTemp=zeros(Bands,1);
for i=1:Row
            for j=1:Column          
        for l=1:ClassNo
            summation=0;
            InputImageTemp(:,1)=InputImage(i,j,:);
            seedTemp=seed(:,l);
            XiMinCjTemp=InputImageTemp-seedTemp;
            XiMinCj= sum((XiMinCjTemp).^2);
            
            for k=1:ClassNo
                % Xi min =ci-cj          
                seed1Temp=seed(:,k);
                XiMinTemp=sum((InputImageTemp-seed1Temp).^2);
                XiMin= XiMinCj/XiMinTemp;
                XiMinCk2m=(XiMin)^(1/(m-1));
                summation=summation+XiMinCk2m;
            end
        Membe_func(i,j,l)=1/summation;
        end
            end
end
end

