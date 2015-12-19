function plotCollecation(data)
% title，所画图表的标题。
%plotParms  里有数据（data），说明文字（info），（线形）style，（子标题）suptitle
%showStyle   指示各个图是否显示同一个figure   0——分开显示   1——显示在同一个figure里

%QAM = [0.3162+0.3162i, 0.3162-0.3162i, -0.3162+0.3162i,-0.3162-0.3162i,0.9487+0.9487i,0.9487-0.9487i,-0.9487+0.9487i,-0.9487-0.9487i,...
%     0.3162+0.9487i,0.3162-0.9487i,0.9487+0.3162i,0.9487-0.3162i,-0.3162+0.9487i,-0.3162-0.9487i,-0.9487+0.3162i,-0.9487-0.3162i];
QPSK = [0.707+0.707i,-0.707+0.707i,-0.707-0.707i,0.707-0.707i];
[height, width] = size(data);
dataIn = reshape(data, height*width, 1);
figure;

plot(real(dataIn),imag(dataIn),'r.');
axis([-12 12 -12 12])
title('高斯白噪声_5M带宽-4导频星座图');
grid on;
hold on;
% 16QAM
plot(real(QPSK),imag(QPSK),'ko');
