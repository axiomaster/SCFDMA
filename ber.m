function Measures = ber( dataIn, dataOut )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% persistent ber;
% if isempty(ber)
%     ber = comm.ErrorRate;
% end
ber = comm.ErrorRate;
Measures = step(ber, dataIn, dataOut);
%disp(Measures);
end

