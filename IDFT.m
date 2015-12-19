function x = IDFT(in)
[M,H] = size(in);
%IDFT
% persistent hIFFT;
% if isempty(hIFFT)
%     hIFFT = dsp.IFFT;
% end
x = ifft(in);
x = x.*sqrt(M);
% x=reshape(x,M*H,1);
end

