function hD = ChanEstimate_1Tx(csrRx, Ref, sim_param)
%#codegen
% Assume same number of Tx and Rx antennas = 1
% Initialize output buffer
hD = complex(zeros(sim_param.M, 14-sim_param.N_pilot-1, sim_param.Rx));
% Estimate channel based on CSR - per antenna port
% csrRx = reshape(Rx, numel(Rx)/4, 4); % Align received pilots with reference pilots
for i=1:sim_param.Rx
    hp      = csrRx(:,:,i)./Ref;                  % Just divide received pilot by reference pilot
    switch sim_param.interMode
        case 'average'
            tmp=interpolate_average(hp);
        case 'lagrange'
            tmp=interpolate_lagrange(hp);
        case 'spline'
            tmp=interpolate_spline(hp, sim_param.mapper_type);            
    end    
    hD(:,:,i) = tmp;
end

end





