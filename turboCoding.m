function [out, Kplus] = turboCoding(in, sim_param)
%turbo����

persistent hCBTEnc1;
if isempty(hCBTEnc1)
    % Turbo Encoder - CB level, C==1
    hCBTEnc1 = comm.TurboEncoder('TrellisStructure', sim_param.trellis, ...
        'InterleaverIndicesSource',  'Input port');
end

inLen = size(in, 1);
%% ����Kplus:turbo������ɢֵ���������ݵ���С��
validK = [40:8:512 528:16:1024 1056:32:2048 2112:64:6144].';
temp = find(validK >= inLen);
Kplus = validK(temp(1), 1);     % minimum K

%% �޸�ԭ���� -> lteIntrlvrIndices����ļ�
[f1, f2] = getf1f2(Kplus);
Idx      = (0:Kplus-1).';
intrlvrIndices  =  mod(f1*Idx + f2*Idx.^2, Kplus) + 1;
%% 
G = sim_param.userBits;
% Initialize output
out = false(G, 1);
%% Turbo encode
tEncCbData = step(hCBTEnc1, in, intrlvrIndices);
%% ����ƥ��
rmCbData = rateMatching(tEncCbData,Kplus,1,G);
% unify code paths
out = logical(rmCbData);
% [EOF]
