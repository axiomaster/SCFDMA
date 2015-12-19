function data = genPayload(N_pilot, chanBW, modType)
%N_pilot 导频数量
%chanBW 信道贷款参数
%% QPSK
%1416,二导频 3M带宽
%2408,二导频 5M带宽
%1192,四导频 3M带宽
%1992,四导频 5M带宽
%% 16QAM
%2856,二导频 3M带宽
%4776,二导频 5M带宽
%2408,四导频 3M带宽
%4008,四导频 5M带宽
%% 
payload = zeros(2,2,2);%导频，带宽，调制方式
payload(:,:,1) = [1416,2408;1192,1992];%QPSK
payload(:,:,2) = [2856,4776;2408,4008];%16QAM
outLen = payload(N_pilot/2,chanBW-1,modType);
data = logical(randi( [0 1], outLen, 1));
% [EOF]