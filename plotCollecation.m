function plotCollecation(data)
% title������ͼ��ı��⡣
%plotParms  �������ݣ�data����˵�����֣�info���������Σ�style�����ӱ��⣩suptitle
%showStyle   ָʾ����ͼ�Ƿ���ʾͬһ��figure   0�����ֿ���ʾ   1������ʾ��ͬһ��figure��

%QAM = [0.3162+0.3162i, 0.3162-0.3162i, -0.3162+0.3162i,-0.3162-0.3162i,0.9487+0.9487i,0.9487-0.9487i,-0.9487+0.9487i,-0.9487-0.9487i,...
%     0.3162+0.9487i,0.3162-0.9487i,0.9487+0.3162i,0.9487-0.3162i,-0.3162+0.9487i,-0.3162-0.9487i,-0.9487+0.3162i,-0.9487-0.3162i];
QPSK = [0.707+0.707i,-0.707+0.707i,-0.707-0.707i,0.707-0.707i];
[height, width] = size(data);
dataIn = reshape(data, height*width, 1);
figure;

plot(real(dataIn),imag(dataIn),'r.');
axis([-12 12 -12 12])
title('��˹������_5M����-4��Ƶ����ͼ');
grid on;
hold on;
% 16QAM
plot(real(QPSK),imag(QPSK),'ko');
