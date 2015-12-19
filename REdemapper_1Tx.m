function [data, csr] = REdemapper_1Tx(in, sim_param)
N = sim_param.N;
M = sim_param.M;
N_pilot = sim_param.N_pilot;

rx = sim_param.Rx;
data = complex(zeros(M, 14-N_pilot, rx));
csr = complex(zeros(M,N_pilot, rx));
dataIn=zeros(M,14,rx);
%% 循环移位
in=circshift(in,M/2);
for x=1:M
   dataIn(x,:,:)=in(x,:,:); 
end

%% 分离用户数据和csr
switch N_pilot
    case 2
        data(:,1:3,:) = dataIn(:,1:3,:);
        csr(:,1,:) = dataIn(:,4,:);
        data(:,4:9,:) = dataIn(:,5:10,:);
        csr(:,2,:) = dataIn(:,11,:);
        data(:,10:12,:) = dataIn(:,12:14,:);
    case 4
%% 导频位置3,6,9,12        
%         data(:,1:2,:)=dataIn(:,1:2,:);
%         csr(:,1,:)=dataIn(:,3,:);
%         data(:,3:4,:)=dataIn(:,4:5,:);
%         csr(:,2,:)=dataIn(:,6,:);
%         data(:,5:6,:)=dataIn(:,7:8,:);
%         csr(:,3,:)=dataIn(:,9,:);
%         data(:,7:8,:)=dataIn(:,10:11,:);
%         csr(:,4,:)=dataIn(:,12,:);
%         data(:,9:10,:)=dataIn(:,13:14,:);
%% 导频位置1,5,9,13       
        csr(:,1,:)=dataIn(:,1,:);
        data(:,1:3,:)=dataIn(:,2:4,:);
        csr(:,2,:)=dataIn(:,5,:);
        data(:,4:6,:)=dataIn(:,6:8,:);
        csr(:,3,:)=dataIn(:,9,:);
        data(:,7:9,:)=dataIn(:,10:12,:);
        csr(:,4,:)=dataIn(:,13,:);
        data(:,10,:)=dataIn(:,14,:);
end
end
