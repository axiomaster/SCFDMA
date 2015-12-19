%% SC-FDMA�������
...////////////////////////////////////////////////////
...������Ӣ�ĵ������ŵ�����
...�����ŵ�����
...////////////////////////////////////////////////////
clear all;clear functions;
disp('SC-FDMA: 1x8, spline');
%% ���ز���
sim_param = sim_params();
%% ������ѭ��
frames=10; %�����֡�� 1000
errframes8 = zeros(11,1);% ��֡��ͳ��
errbits8=zeros(11,1);        %�������ͳ��
%% ����
for snr=0:10;
    sim_param.snrdB  = snr*3;      %��˹������ snr*3
    for i=1:frames
        measure  = sim_step(sim_param); 
        errbits8(snr+1) = errbits8(snr+1) + measure(1);
        if(measure(1)>0)
            errframes8(snr+1) = errframes8(snr+1) +1;
        end
    end  
    errbits8(snr+1) = errbits8(snr+1)/frames;
    errframes8(snr+1) = errframes8(snr+1)/frames;
    disp(snr);
end
disp('sim over~~~~~~~~~~');