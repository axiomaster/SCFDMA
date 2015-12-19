function zVisualize( in )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
persistent hScope1
if isempty(hScope1)
    % Constellation Diagrams
    hScope1 = comm.ConstellationDiagram('ShowReferenceConstellation', false,...
        'YLimits', [-3 3], 'XLimits', [-3 3], 'Position', ...
        figposition([5 60 20 25]), 'Name', 'Before Equalizer');
    if verLessThan('comm','5.5')
        hScope1.SymbolsToDisplay=1800;
    end
end
[x, y] = size(in);
data = reshape(in, x*y, 1);
step(hScope1, data);

end

