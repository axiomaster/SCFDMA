function dftOut = DFT(dftIn, M, N_pilot)
%% DFT
% 1 ת��Ϊ����-> �����任
dftMtrix = reshape(dftIn, [M, 14-N_pilot-1]);
% % 2 dft����
dftOut = fft(dftMtrix);
dftOut =  dftOut./sqrt(M);
end