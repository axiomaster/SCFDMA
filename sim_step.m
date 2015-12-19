%每次一个帧
function Measures= sim_step(sim_param) %[dataIn, chanOut]   Measures  [x, Measures] 
%% ---------------------发射部分--------------------------%
%% 用户载荷
dataIn = genPayload(sim_param.N_pilot, sim_param.chanBW, sim_param.modType);
% 添加CRC
crcOut =CRCgenerator(dataIn);
%% 信道编码 - 速率匹配
coded_bits = LTE_tx_turbo_encode_code_block(sim_param,crcOut');
% [codingOut1, Kplus1] = turboCoding(crcOut, sim_param);
% load('Kplus1.mat');
%% 速率匹配
[codingOut,UE_signaling] = LTE_UL_tx_turbo_rate_matcher2(sim_param,coded_bits);
%% 扰码
scramOut = scramble(codingOut{1,1}', sim_param.userBits);
%% 调制
modOut = Modulator(scramOut, sim_param.modType);
%% DFT运算
dftOut = DFT(modOut, sim_param.M, sim_param.N_pilot);
%% 导频 - CSR参考信号
csr_ref = CSRgenerator(sim_param.M, sim_param.N_pilot);
% load('csr_ref.mat');
%% 映射
mapperOut = REmapper_1Tx(dftOut, csr_ref, sim_param.mapper_type);
%% OFMD发射
ofdmTxOut = OFDMTx(mapperOut, sim_param);
% % ---------------------信道部分--------------------------%
%% 信道衰落
[chanOut, chPathG] = channel(ofdmTxOut, sim_param);
% load('chanOut.mat');
%% 高斯噪声        
% snr = sim_param.snrdB + 10*log10(2) + 10*log10(1/3);
% % nVar = 10.^(-snr/10);
nVar = 10.^(-sim_param.snrdB/10);
rxSig =  AWGNChannel(chanOut, sim_param.snrdB);
% %% ---------------------接收部分--------------------------%
% %% OFMD接收
ofdmRxOut = OFDMRx(rxSig, sim_param);
% %% 解映射
[dataRx, csrRx] = REdemapper_1Tx(ofdmRxOut, sim_param);
%% 信道估计
if sim_param.chanEstOn
    hD = ChanEstimate_1Tx(csrRx,  csr_ref, sim_param);
else
    hD = idealChanEstimate_1Tx(chPathG, sim_param);
end
%% 均衡
[eqOut,Hg,noise_enhancement] = Equalizer(dataRx, hD, nVar, sim_param.Eqmode);
% %% IDFT运算
idftOut = IDFT(eqOut);
%% 解调
% zVisualize(idftOut);
% % mesh(abs(idftOut)); %信道图
% Hg=ones(1,10);
% noise_enhancement=ones(2,180,10);
LLR_SD = DemodulatorSoft(idftOut, sim_param.modType, nVar);
% LLR_SD = demod1(idftOut,Hg,noise_enhancement,sim_param.modType);
%% 解扰
descrambleOut=descramble(LLR_SD,sim_param.userBits);
%% 速率匹配  turbo译码
turboDecodeOut = rateDematch( sim_param,-descrambleOut,UE_signaling );
% [turboDecodeOut, ~,~] = turboDecode(descrambleOut, Kplus1, sim_param);
%% CRC校验
[dataOut, err] = CRCdetector(turboDecodeOut');
%% 子帧-误比特统计
Measures = ber(dataIn, dataOut);
end