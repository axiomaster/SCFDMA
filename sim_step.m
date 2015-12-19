%ÿ��һ��֡
function Measures= sim_step(sim_param) %[dataIn, chanOut]   Measures  [x, Measures] 
%% ---------------------���䲿��--------------------------%
%% �û��غ�
dataIn = genPayload(sim_param.N_pilot, sim_param.chanBW, sim_param.modType);
% ���CRC
crcOut =CRCgenerator(dataIn);
%% �ŵ����� - ����ƥ��
coded_bits = LTE_tx_turbo_encode_code_block(sim_param,crcOut');
% [codingOut1, Kplus1] = turboCoding(crcOut, sim_param);
% load('Kplus1.mat');
%% ����ƥ��
[codingOut,UE_signaling] = LTE_UL_tx_turbo_rate_matcher2(sim_param,coded_bits);
%% ����
scramOut = scramble(codingOut{1,1}', sim_param.userBits);
%% ����
modOut = Modulator(scramOut, sim_param.modType);
%% DFT����
dftOut = DFT(modOut, sim_param.M, sim_param.N_pilot);
%% ��Ƶ - CSR�ο��ź�
csr_ref = CSRgenerator(sim_param.M, sim_param.N_pilot);
% load('csr_ref.mat');
%% ӳ��
mapperOut = REmapper_1Tx(dftOut, csr_ref, sim_param.mapper_type);
%% OFMD����
ofdmTxOut = OFDMTx(mapperOut, sim_param);
% % ---------------------�ŵ�����--------------------------%
%% �ŵ�˥��
[chanOut, chPathG] = channel(ofdmTxOut, sim_param);
% load('chanOut.mat');
%% ��˹����        
% snr = sim_param.snrdB + 10*log10(2) + 10*log10(1/3);
% % nVar = 10.^(-snr/10);
nVar = 10.^(-sim_param.snrdB/10);
rxSig =  AWGNChannel(chanOut, sim_param.snrdB);
% %% ---------------------���ղ���--------------------------%
% %% OFMD����
ofdmRxOut = OFDMRx(rxSig, sim_param);
% %% ��ӳ��
[dataRx, csrRx] = REdemapper_1Tx(ofdmRxOut, sim_param);
%% �ŵ�����
if sim_param.chanEstOn
    hD = ChanEstimate_1Tx(csrRx,  csr_ref, sim_param);
else
    hD = idealChanEstimate_1Tx(chPathG, sim_param);
end
%% ����
[eqOut,Hg,noise_enhancement] = Equalizer(dataRx, hD, nVar, sim_param.Eqmode);
% %% IDFT����
idftOut = IDFT(eqOut);
%% ���
% zVisualize(idftOut);
% % mesh(abs(idftOut)); %�ŵ�ͼ
% Hg=ones(1,10);
% noise_enhancement=ones(2,180,10);
LLR_SD = DemodulatorSoft(idftOut, sim_param.modType, nVar);
% LLR_SD = demod1(idftOut,Hg,noise_enhancement,sim_param.modType);
%% ����
descrambleOut=descramble(LLR_SD,sim_param.userBits);
%% ����ƥ��  turbo����
turboDecodeOut = rateDematch( sim_param,-descrambleOut,UE_signaling );
% [turboDecodeOut, ~,~] = turboDecode(descrambleOut, Kplus1, sim_param);
%% CRCУ��
[dataOut, err] = CRCdetector(turboDecodeOut');
%% ��֡-�����ͳ��
Measures = ber(dataIn, dataOut);
end