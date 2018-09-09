function [ OutputImage ] = FinalOutput( InputImage,Membe_func)

[Row,Column,~]=size(InputImage);
OutputImage=zeros(Row,Column);
for i=1:Row*Column
                row=ceil(i/Column);
                col=i-(row-1)*Column; 
                dist=Membe_func(i,:);
                [~,in]=max(dist);
                OutputImage(col,row)=in;
    
end
end
