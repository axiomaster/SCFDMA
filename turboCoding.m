function [out, Kplus] = turboCoding(in, sim_param)
%turbo编码

persistent hCBTEnc1;
if isempty(hCBTEnc1)
    % Turbo Encoder - CB level, C==1
    hCBTEnc1 = comm.TurboEncoder('TrellisStructure', sim_param.trellis, ...
        'InterleaverIndicesSource',  'Input port');
end

inLen = size(in, 1);
%% 计算Kplus:turbo编码离散值，输入数据的最小界
validK = [40:8:512 528:16:1024 1056:32:2048 2112:64:6144].';
temp = find(validK >= inLen);
Kplus = validK(temp(1), 1);     % minimum K

%% 修改原程序 -> lteIntrlvrIndices这个文件
[f1, f2] = getf1f2(Kplus);
Idx      = (0:Kplus-1).';
intrlvrIndices  =  mod(f1*Idx + f2*Idx.^2, Kplus) + 1;
%% 
G = sim_param.userBits;
% Initialize output
out = false(G, 1);
%% Turbo encode
tEncCbData = step(hCBTEnc1, in, intrlvrIndices);
%% 速率匹配
rmCbData = rateMatching(tEncCbData,Kplus,1,G);
% unify code paths
out = logical(rmCbData);
% [EOF]
