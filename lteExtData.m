function [y, csrRx] = lteExtData(in, sim_param)
%#codegen此函数的功能就是将输入的180x14的in变为
% y（180x12  或者 180x10）  和csrRx（180x2   或者180x4）

% varargin{1} = 'data' for data extraction, default - not needed as input
% varargin{1} = 'chan' for channel extraction when h is given as input

% Copyright 2012 The MathWorks, Inc.

%Inverse of the resource element mapper
%   use it to extract the data elements and supporting elements for further
%   Rx processing.
%   Assumes NcellID = 0;

% Get input params
Nrb = sim_param.Nrb;              % = 100 for 20 MHz
Nrb_sc = sim_param.Nrb_sc;        % = 12
M=sim_param.M;
N=sim_param.N;
numContSymb    = 0;   % control region, numOFDM symbols
numTx = 1;  
numRx = sim_param.Rx;
Npilot=sim_param.N_pilot; 
y_line=14-Npilot;
csrRx_line=Npilot;
mapper_type=sim_param.mapper_type;

%%    根据导频数参数sim_param.N_pilot 来判断分割成何种形式
if(Npilot==2)
    y=zeros(M,12,numRx);
    csrRx=zeros(M,2,numRx);
% 赋值
    y(:,1:3)=in(:,1:3);
    y(:,4:9)=in(:,5:10);
    y(:,10:12)=in(:,12:14);
    csrRx(:,1)=in(:,4);
    csrRx(:,2)=in(:,11);
    
else if(Npilot==4)
    y=zeros(M,10,numRx);
    csrRx=zeros(M,4,numRx);
    switch mapper_type
            case 1           % [3 6 9 12]
                y(:,1:2,:)=in(:,1:2,:);
                y(:,3:4,:)=in(:,4:5,:);
                y(:,5:6,:)=in(:,7:8,:);
                y(:,7:8,:)=in(:,10:11,:);
                y(:,9:10,:)=in(:,13:14,:);
                
%                 csrRx(:,1)=in(:,3);
%                 csrRx(:,2)=in(:,6);
%                 csrRx(:,3)=in(:,9);
%                 csrRx(:,4)=in(:,12);
            case 2           % [2 6 9 13]
                y(:,1:2,:)=in(:,1:2,:);
                y(:,3:4,:)=in(:,4:5,:);
                y(:,5:6,:)=in(:,7:8,:);
                y(:,7:8,:)=in(:,10:11,:);
                y(:,9:10,:)=in(:,13:14,:);
%                 
%                 csrRx(:,1)=in(:,2);
%                 csrRx(:,2)=in(:,6);
%                 csrRx(:,3)=in(:,9);
%                 csrRx(:,4)=in(:,13);
            case 3           % [1 5 9 13]
                y(:,1:3,:)=in(:,2:4,:);
                y(:,4:6,:)=in(:,6:8,:);
                y(:,7:9,:)=in(:,10:12,:);
                y(:,10,:)=in(:,14,:);
%                 
%                 csrRx(:,1)=in(:,1);
%                 csrRx(:,2)=in(:,5);
%                 csrRx(:,3)=in(:,9);
%                 csrRx(:,4)=in(:,13);
            case 4           % [2 6 10 14]
                y(:,1:2,:)=in(:,1:2,:);
                y(:,3:4,:)=in(:,4:5,:);
                y(:,5:6,:)=in(:,7:8,:);
                y(:,7:8,:)=in(:,10:11,:);
                y(:,9:10,:)=in(:,13:14,:); 
                
%                 csrRx(:,1)=in(:,2);
%                 csrRx(:,2)=in(:,6);
%                 csrRx(:,3)=in(:,10);
%                 csrRx(:,4)=in(:,14);
    end 
    end
end
% % y=reshape(y,N_sc*y_line,1);
% % csrRx=reshape(csrRx,N_sc*csrRx_line,1);

%% Determine the data element indices in the input grid
%   Assuming only CSR and data in the incoming grid
%       account for PDCCH, PBCH, PSS, SSS later
% Only 2 reference symbols per RB
% dtIdx_OFDMSym_wCsr = zeros((Nrb_sc-2), Nrb);
% dtIdx_OFDMSym2_wCsr = zeros((Nrb_sc-2), Nrb);
% for i = 1:Nrb
%     dtIdx_OFDMSym_wCsr(:, i) = [2:6 8:12].'+12*(i-1);
%     dtIdx_OFDMSym2_wCsr(:, i) = [1:3 5:9 11:12].'+12*(i-1);
% end
% dtIdx_OFDMSym_wCsrCol = dtIdx_OFDMSym_wCsr(:);
% dtIdx_OFDMSym2_wCsrCol = dtIdx_OFDMSym2_wCsr(:);
% 
% lenOFDM = dtIdx_OFDMSym_wCsrCol(end);
% dtIdx_OFDMSym = (1:lenOFDM).';    
% 
% % Slot filling specific to numTx = 1
% dtIdx_slot = [dtIdx_OFDMSym_wCsrCol; dtIdx_OFDMSym+lenOFDM; ...
%               dtIdx_OFDMSym+2*lenOFDM; dtIdx_OFDMSym+3*lenOFDM;...
%               dtIdx_OFDMSym2_wCsrCol+4*lenOFDM;...
%               dtIdx_OFDMSym+5*lenOFDM; dtIdx_OFDMSym+6*lenOFDM];  
%           
% lenSlot = dtIdx_slot(end);
% dtIdx_subframe = [dtIdx_slot; dtIdx_slot+lenSlot];
% 
% %% 
% % Account for PDCCH - remove the data idxes for these RE - in all subframes
% numContRE = numContSymb * Nrb * Nrb_sc;
% dtIdx_subframe(dtIdx_subframe <= numContRE) = [];
% %% Determine the CSR element indices in the input grid
% % Only 2 reference symbols per RB
% csrIdx = zeros(2, Nrb);
% csrIdx2 = zeros(2, Nrb);
% for i = 1:Nrb
%     csrIdx(:, i) = [1;7]+12*(i-1);
%     csrIdx2(:, i) = [4;10]+12*(i-1);
% end
% csrIdx_Col = csrIdx(:);
% csrIdx2_Col = csrIdx2(:);
% 
% % Slot filling specific to numTx = 1
% csrRx = complex(zeros(Nrb*2*2*2, numTx));
% csrIdx_slot = [csrIdx_Col; csrIdx2_Col+4*lenOFDM];    
% csrIdx_subframe = [csrIdx_slot; csrIdx_slot+lenSlot];
% 
% %% Extract the data and the CSR elements using the indices
% 
% % Switch loop variable depending on input type: rxData or channelEstimate
% colVal = numTx;
% 
% y = complex(zeros(length(dtIdx_subframe), colVal));
% for i = 1:colVal
%     in  = reshape(in(:,:,i), sim_param.numResources, 1);
%     y(:, i)     = in(dtIdx_subframe);
%     csrRx(:, i) = in(csrIdx_subframe);
% end
% [EOF]
