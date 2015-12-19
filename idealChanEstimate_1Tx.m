function [hD,csr_hD] = idealChanEstimate_1Tx(chPathG, sim_param)
%理想信道估计
persistent hFFT; 
if isempty(hFFT) 
   hFFT = dsp.FFT; 
end 

% get parameters
numDataTones = sim_param.M; % Nrb_sc = 12
N            = sim_param.N;
M            =sim_param.M;
cpLen0       = sim_param.cpLen0;
cpLenR       = sim_param.cpLenR;
chanRate     =sim_param.chanSRate;
slotLen = (N*7 + cpLen0 + cpLenR*6);  %1920

%pathDelays = [0,0,1,1,1,3,4,7,10]*1e-9;
%pathDelays = [0 10 20 30 100]*(1/sim_param.chanSRate);
pathDelays=[0 1 3 4 7 10]*(1/chanRate);

% Delays, in terms of number of channel samples, +1 for indexing
sampIdx = round(pathDelays/(1/chanRate)) + 1;

[~, numPaths, numTx, numRx] = size(chPathG);

H = complex(zeros(numDataTones, 14, numTx, numRx));
for i= 1:numTx
    for j = 1:numRx
        link_PathG = chPathG(:, :, i, j);
        % Split this per OFDM symbol
        g = complex(zeros(2*7, numPaths));   %各个路径的 每个ofdm符号出的增益
        for jj = 1:2 % over two slots
            % First OFDM symbol
            g((jj-1)*7+1, :) = mean(link_PathG((jj-1)*slotLen + (1:(N+cpLen0)), :), 1);
            
            % Next 6 OFDM symbols
            for k = 1:6
                g((jj-1)*7+k+1, :) = mean(link_PathG((jj-1)*slotLen+cpLen0+k*N+(k-1)*cpLenR + (1:(N+cpLenR)), :), 1);
            end
        end
        hImp = complex(zeros(2*7, N));
        hImp(:, sampIdx) = g; % assign pathGains at sample locations
%         hImp(:, 1) = g(:,1)+g(:,2);
%         hImp(:, 2) = g(:,3)+g(:,4)+g(:,5);
%         hImp(:, 4) = g(:,6);
%         hImp(:, 5) = g(:,7);
%         hImp(:, 8) = g(:,8);
        % FFT processing
        h = step(hFFT, hImp.'); 

        % 取出数据位置的   180*14的h
        h=circshift(h,M/2);
        H(:,:,i,j)=h(1:M,:);
    end
end
% H - 180x14x2x2

% Now, align these with the data RE per antenna link and reuse them
[H_rx1, csrRx1] = lteExtData( squeeze(H), sim_param);
hD=H_rx1;
csr_hD=csrRx1;
% hD =  complex(zeros(size(H_rx1,1), numTx, numRx));
% hD(:,:,1) = H_rx1;
% csrRx =  complex(zeros(size(csrRx1,1), numTx, numRx));
% csrRx(:,:,1) = csrRx1;
% for i = 2:numRx
%     [hD(:,:,i), csr_hD(:,:,i)] = lteExtData( squeeze(H(:,:,:,i)), nS, prmLTEPDSCH, 'chan');
% end


end