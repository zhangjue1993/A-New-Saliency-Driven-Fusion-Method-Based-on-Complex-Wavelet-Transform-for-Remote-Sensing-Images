function [ Membe_func ] = CalculatingMembershipFunc_new(m,ClassNo,img,seed )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
[Row,~]=size(img);
Membe_func=zeros(Row,ClassNo);
D=zeros(Row,ClassNo);
 
 for k=1:ClassNo
 D(:,k)=sum((double(img)-seed(k,:)).^2,2);
  end    

 for i=1:Row                                   
     for k=1:ClassNo
     
           Membe_func(i,k)=1/((D(i,k)./D(i,:))*(D(i,k)./D(i,:))');    
           %Membe_func(i,k)=1/sum((D(i,k)./D(i,:)).^2); 
     end    
               
end


end

