function x = OFDMRx(in, sim_param)
%#codegen
% persistent hFFT;
% if isempty(hFFT)
%     hFFT = dsp.FFT;
% end
% For a subframe of data
numSymb = sim_param.N_symb*2; 
[~, rx] = size(in);
% N assumes 15KHz subcarrier spacing, else N = 4096
N = sim_param.N;
M=sim_param.M;
cpLen0 = sim_param.cpLen0;
cpLenR = sim_param.cpLenR;
slotLen = (N*7 + cpLen0 + cpLenR*6);
tmp = complex(zeros(N, numSymb, rx));
% Remove CP - unequal lengths over a slot
for j = 1:2 % over two slots
    % First OFDM symbol
    tmp(:, (j-1)*7+1, :) = in((j-1)*slotLen+cpLen0 + (1:N), :);

    % Next 6 OFDM symbols
    for k = 1:6
        tmp(:, (j-1)*7+k+1, :) = in((j-1)*slotLen+cpLen0+k*N+k*cpLenR + (1:N), :);
    end    
end
% FFT processing
x = fft(tmp);
x =  x./sqrt(N);