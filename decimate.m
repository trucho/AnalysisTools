function y=decimate(x,Factor)
% function y=decimate(x,Factor)
% Just downsampling, no filtering.
% Created Angueyra Dec_2014 due to lack of Signal Processing Toolbox

validateattributes(Factor,{'double'},{'integer'});

% xend=floor(length(x)/Factor);
y=x(1:Factor:end);


