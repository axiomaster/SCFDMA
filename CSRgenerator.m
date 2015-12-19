function csr_ref = CSRgenerator(M, N_pilot)
nS = 4;
%  LTE Cell-Specific Reference signal generation.
%   Section 6.10.1 of 3GPP TS 36.211 v10.0.0.
%   Generate the whole set per OFDM symbol, for 2 OFDM symbols per slot,
%   for 2 slots per subframe, per antenna port (numTx). 
%   This fcn accounts for the per antenna port sequence generation, while
%   the actual mapping to resource elements is done in the Resource mapper.
%#codegen
persistent hSeqGen;
persistent hInt2Bit;
% Assumed parameters
NcellID = 0;        % One of possible 504 values
Ncp = 1;            % for normal CP, or 0 for Extended CP
NmaxDL_RB = 100;    % largest downlink bandwidth configuration, in resource blocks
% y = complex(zeros(NmaxDL_RB*2, 2, 2, numTx));
y = complex(zeros(NmaxDL_RB*12, 1, 2));
% 时隙内导频的位置
l = [3];     % OFDM symbol idx in a slot for common first antenna port
% Buffer for sequence per OFDM symbol
seq = zeros(size(y,1)*2, 1); % *2 for complex outputs
% seq = zeros(2400,1);
if isempty(hSeqGen)
    hSeqGen = comm.GoldSequence('FirstPolynomial',[1 zeros(1, 27) 1 0 0 1],...
                                'FirstInitialConditions', [zeros(1, 30) 1], ...
                                'SecondPolynomial', [1 zeros(1, 27) 1 1 1 1],...
                                'SecondInitialConditionsSource', 'Input port',... 
                                'Shift', 1600,...
                                'SamplesPerFrame', length(seq));
    hInt2Bit = comm.IntegerToBit('BitsPerInteger', 31);
end
% Generate the common first antenna port sequences
for i = 1:2 % slot wise，每子帧两个时隙
    for lIdx = 1:1 % symbol wise， 每时隙内一个符号
        c_init = (2^10)*(7*((nS+i-1)+1)+l(lIdx)+1)*(2*NcellID+1) + 2*NcellID + Ncp;
        % Convert to binary vector
        iniStates = step(hInt2Bit, c_init);
        % Scrambling sequence - as per Section 7.2, 36.211
        seq = step(hSeqGen, iniStates); 
        % Store the common first antenna port sequences
        y(:, lIdx, i, 1) = (1/sqrt(2))*complex(1-2.*seq(1:2:end), 1-2.*seq(2:2:end));
    end
end
%% 截取需要的导频数量，返回M*N矩阵
E= M*N_pilot;
csr_ref=reshape(y(1:E),M,N_pilot);
end