function y = AWGNChannel(u, snr_dB )
%% Initialization
n_rs = RandStream('mt19937ar',...
                              'Seed',10,...
                              'NormalTransform','Ziggurat');
n = (randn(n_rs,size(u))+1i*randn(n_rs,size(u)))*10^(-snr_dB/20)/sqrt(2);
y = u+n;
% persistent AWGN
% if isempty(AWGN)
%     AWGN             = comm.AWGNChannel('NoiseMethod', 'Variance', ...
%     'VarianceSource', 'Input port');
% end
% y = step(AWGN, u, noiseVar);
% disp(noiseVar);
end

