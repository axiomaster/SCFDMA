function y = OFDMTx(in, sim_param)
%#codegen
% persistent hIFFT;
% if isempty(hIFFT)
%     hIFFT = dsp.IFFT;
% end
[len, numSymb] = size(in);
% N assumes 15KHz subcarrier spacing
N = sim_param.N;
M=sim_param.M;
cpLen0 = sim_param.cpLen0;
cpLenR = sim_param.cpLenR;
slotLen = (N*7 + cpLen0 + cpLenR*6);
subframeLen = slotLen*2;  
tmp = complex(zeros(N, numSymb));
%将180*14放入256*14中，放到中间，两边补零
tmp(1:M,:)=in;
tmp=circshift(tmp,-(M/2));
% left = (N-len)/2+1;
% right = left + len -1;
% tmp(left:right,:) = in(1:len,:);
% % Pack data, add DC, and reorder
% tmp(N/2-len/2+1:N/2, :, :) = in(1:len/2, :, :);
% tmp(N/2+2:N/2+1+len/2, :, :) = in(len/2+1:len, :, :);
% tmp = [tmp(N/2+1:N, :, :); tmp(1:N/2, :, :)];
% IFFT processing
x = ifft(tmp);
x = x.*sqrt(N); %归一化
% Add cyclic prefix per OFDM symbol per antenna port 
% and serialize over the subframe (equal to 2 slots)
% For a subframe of data
y = complex(zeros(subframeLen, 1));
 for j = 1:2 % Over the two slots 俩时隙
    % First OFDM symbol
    y((j-1)*slotLen+(1:cpLen0), :) = x((N-cpLen0+1):N, (j-1)*7+1, :);
    y((j-1)*slotLen+cpLen0+(1:N), :) = x(1:N, (j-1)*7+1, :);

    % Next 6 OFDM symbols
    for k = 1:6
        y((j-1)*slotLen+cpLen0+k*N+(k-1)*cpLenR+(1:cpLenR), :) = x(N-cpLenR+1:N, (j-1)*7+k+1, :);
        y((j-1)*slotLen+cpLen0+k*N+k*cpLenR+(1:N), :) = x(1:N, (j-1)*7+k+1, :);
    end
end