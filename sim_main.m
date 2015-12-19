%% SC-FDMA仿真入口
...////////////////////////////////////////////////////
...集成阮英文的理想信道估计
...理想信道估计
...////////////////////////////////////////////////////
clear all;clear functions;
disp('SC-FDMA: 1x8, spline');
%% 加载参数
sim_param = sim_params();
%% 仿真主循环
frames=10; %仿真的帧数 1000
errframes8 = zeros(11,1);% 误帧率统计
errbits8=zeros(11,1);        %误比特率统计
%% 测试
for snr=0:10;
    sim_param.snrdB  = snr*3;      %高斯白噪声 snr*3
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