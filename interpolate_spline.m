function hD = interpolate_spline( hp )
[M, N_pilot] = size(hp);

tmp = complex(zeros(M, 14));
x = 1:14;
%样条内插
switch N_pilot
    case 2 %2导频
        m = [4,11];
    case 4
        %% 导频位置3,6,9,12
%         m = [3,6,9,12];      
        %% 导频位置1，5,9,13
        m = [1,5,9,13];                
end

for i=1:M
%     tmp(i,x) = interp1(m,hp(i,:),x,'spline');     
    tmp(i,x) = interp1(m,hp(i,:),x,'spline');  
end
switch N_pilot
    case 2 %2导频
        hD(:,1:3) = tmp(:,1:3);
        hD(:,4:9) = tmp(:,5:10);
        hD(:,10:12) = tmp(:,12:14);
    case 4
        %% 导频位置3,6,9,12
%         hD(:,1:2) = tmp(:,1:2);
%         hD(:,3:4) = tmp(:,4:5);
%         hD(:,5:6) = tmp(:,7:8);
%         hD(:,7:8) = tmp(:,10:11);
%         hD(:,9:10) = tmp(:,13:14);
        %% 导频位置1,5,9,13
        hD(:,1:3) = tmp(:,2:4);
        hD(:,4:6) = tmp(:,6:8);
        hD(:,7:9) = tmp(:,10:12);
        hD(:,10) = tmp(:,14);
end