function [decTbData, crcCbFlags, iters] = turboDecode(in,Kplus, sim_param)  
% Gate = 31;
% for i=1:size(in)
%     if(in(i)>Gate)
%         in(i) = Gate;
%     end
%     if(in(i)<-Gate)
%         in(i) = -Gate;
%     end
% end
C = 1;%Âë¿é·Ö¸î
% persistent hCBTDec;
% if isempty(hCBTDec)
    % Turbo Decoder - CB level
    hCBTDec = comm.TurboDecoder('TrellisStructure', sim_param.trellis,...
        'InterleaverIndicesSource',  'Input port', ...
        'NumIterations', sim_param.maxIter);
% end
%% lteIntrlvrIndices
[f1, f2] = getf1f2(Kplus);
Idx      = (0:Kplus-1).';
intrlvrIndices  =  mod(f1*Idx + f2*Idx.^2, Kplus) + 1;
%% 
% Make fixed size and not var-size as scalar varS is not supported yet
crcCbFlags = zeros(1, 1);            % default as no errors
iters      = zeros(1, 1);
G = sim_param.userBits; % default

% Channel decoding the TB

% Rate dematching, with bit insertion
%   Flip input polarity to match decoder output bit mapping
deRMCbData = rateDematching(in, Kplus, C, G);

% Turbo decode the single CB
tDecCbData = step(hCBTDec, deRMCbData, intrlvrIndices);

% Unify code paths
decTbData  = logical(tDecCbData);
crcCbFlags(1) = 0; % no errors
iters(1)      = sim_param.maxIter;
% [EOF]