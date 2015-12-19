function dftOut = DFT(dftIn, M, N_pilot)
%% DFT
% 1 转换为矩阵-> 串并变换
dftMtrix = reshape(dftIn, [M, 14-N_pilot-1]);
% % 2 dft运算
dftOut = fft(dftMtrix);
dftOut =  dftOut./sqrt(M);
end