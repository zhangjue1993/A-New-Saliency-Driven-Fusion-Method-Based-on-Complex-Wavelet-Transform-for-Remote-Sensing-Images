function P=HistogramMatch(I_PAN,I)
M_PAN = mean2(I_PAN);
M_I = mean2(I);
Sigma_PAN = std2(I_PAN);
Sigma_I = std2(I);
 P=Sigma_I/Sigma_PAN.*(I_PAN-M_PAN)+M_I;
 %P=(I_PAN-M_PAN)+M_I;

end
