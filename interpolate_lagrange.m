function hD=interpolate_lagrange(hp)
[M, N_pilot] = size(hp);
hD = complex(zeros(M, 14-N_pilot));
% 拉格朗日内插
i = 1;
switch N_pilot
    case 2 %2导频
        common = 1/(11-4);
        for m=[1:3 5:10 12:14]
            alpha=common*(m-4);
            beta=1-alpha;
            hD(:,i)    = beta*hp(:,1) + alpha*hp(:,2);
            i = i+1;
        end        
    case 4
        for m=[1:2 4:5 7:8 10:11 13:14]
            a1 = -(m-6)*(m-9)*(m-12)/162;
            a2 = (m-3)*(m-9)*(m-12)/54;
            a3 = -(m-3)*(m-6)*(m-12)/54;
            a4 = (m-3)*(m-6)*(m-9)/162;
            hD(:,i)    = a1*hp(:,1) + a2*hp(:,2) + a3*hp(:,3) + a4*hp(:,4);
            i = i+1;
        end                
end


