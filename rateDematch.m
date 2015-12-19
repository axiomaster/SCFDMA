function output = rateDematch( sim_param,descrambleOut,BS_signaling )

d = LTE_UL_rx_turbo_rate_matcher(sim_param,descrambleOut,BS_signaling);
F=40;
d{1}([1 2],1:F) = -10;

[ output error_bits ] = LTE_rx_turbo_decode_codeword(sim_param,d{1},sim_param.maxIter,1);
end

