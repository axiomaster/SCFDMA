function LLR = demod1(in,Hg,noise_enhancement, modType)
% idftOut=reshape(in,180,10);
switch modType
    case 1,
        symbol_alphabet=[ 1+1j, 1-1j, -1+1j, -1-1j]/sqrt(2);
        bittable=logical([0 0 1 1;1 0 1 0]);
    case 2,
        load('symbol_alphabet');
        load('bittable');
end
idftOut=in;
[M,H]=size(idftOut);
LLR_SD=zeros(2,M*H);
index=0;
for i=1:H
    LLR_SD(:,index+1:index+M) = LTE_demapper(idftOut(:,i)',symbol_alphabet,bittable,1,2,Hg(i),noise_enhancement(:,:,i)); %,receiver
    index = index+M;
end
LLR=reshape(LLR_SD,M*H*2,1);