function hD=interpolate_average(hp)
[M, N_pilot] = size(hp);
p = complex(zeros(M, 1));
for i=1:N_pilot
    p = p+hp(:,i);
end
p = p/N_pilot;

for i=1:(14-N_pilot)
    hD(:,i) = p(:,1);
end
end
