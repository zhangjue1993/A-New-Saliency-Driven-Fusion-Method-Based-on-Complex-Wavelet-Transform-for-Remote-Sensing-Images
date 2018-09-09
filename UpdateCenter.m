function [ NewSeed ] = UpdateCenter( m,ClassNo,Membe_func,img )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[~,b]=size(img);
NewSeed=zeros(ClassNo,b);TempRory1=img(:,:);
for i=1:ClassNo
        TempRor=Membe_func(:,i);
        %TempRory=[(TempRor).^m  (TempRor).^m  (TempRor).^m  ];
        TempRory=repmat((TempRor).^m,1,b);
        NewSeed(i,:)=(sum(TempRory.*TempRory1))./sum(TempRory);

end

end

