function data = genPayload(N_pilot, chanBW, modType)
%N_pilot ��Ƶ����
%chanBW �ŵ��������
%% QPSK
%1416,����Ƶ 3M����
%2408,����Ƶ 5M����
%1192,�ĵ�Ƶ 3M����
%1992,�ĵ�Ƶ 5M����
%% 16QAM
%2856,����Ƶ 3M����
%4776,����Ƶ 5M����
%2408,�ĵ�Ƶ 3M����
%4008,�ĵ�Ƶ 5M����
%% 
payload = zeros(2,2,2);%��Ƶ���������Ʒ�ʽ
payload(:,:,1) = [1416,2408;1192,1992];%QPSK
payload(:,:,2) = [2856,4776;2408,4008];%16QAM
outLen = payload(N_pilot/2,chanBW-1,modType);
data = logical(randi( [0 1], outLen, 1));
% [EOF]