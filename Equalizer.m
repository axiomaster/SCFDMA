function [out,Hg,noise_enhancement] = Equalizer(in, hD, nVar, EqMode)
[M,H,nRX]=size(hD);
out=zeros(M,H);
Hg=zeros(1,H);
noise_enhancement=zeros(2,M,H);
for i=1:H
    temp = conj(hD(:,i,:));
    switch EqMode
        case 1,   % Zero forcing
           num = conj(hD);
           denum=conj(hD).*hD;            
        case 2,   % MMSE ÖðÁÐ´¦Àí
            for j=1:nRX
               inv_temp(:,:,j) = temp(:,:,j)./sum(hD(:,i,:).*temp+nVar,3);
            end
               Hg(i) = mean(sum(inv_temp.*hD(:,i,:),3));    
        otherwise,
            error('Two equalization mode available: Zero forcing or MMSE');
    end   
    out(:,i) = transpose(sum(inv_temp.*in(:,i,:),3));
    noise_enhancement(:,:,i) = nVar*mean(sum(abs(inv_temp).^2,3),1)*ones(2,M);
end
end