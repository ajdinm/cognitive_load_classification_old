function [ filtered_signal ] = moving_avg_filter(signal, step)
%moving_avg_filter Preformes moving avg_filter on signal
%   Detailed explanation goes here

coeff = ones(1, step) / step;
filtered_signal = filter(coeff, 1, signal);

end