function [ points ] = plot_lines( points, extrema )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    for i = 1:length(points)
        current_segment = points(i,:);
        line([current_segment(1) current_segment(1)], [extrema(1) extrema(2)], 'Color', 'yellow')
        line([current_segment(2) current_segment(2)], [extrema(1) extrema(2)], 'Color', 'yellow')
    end
end