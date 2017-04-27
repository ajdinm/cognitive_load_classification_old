function [ filtered_signal ] = clean_pupil_diameter(signal)

    filtered_signal = moving_avg_filter(signal, 250);       
%   filtered_signal = medfilt1(signal, 3); % doesn't remove peaks

%   pupil diameter cannot be smaller than 2mm; cut off such peaks
    threshold = 0.002;
    filtered_signal(filtered_signal < threshold) = threshold;
end
