function [ cells ] = plot_events(cells, bc_segment, extrema)
    plot(1, 1);
    points = get_event_times(cells(:,1))
    for i = 1:length(points)
        current_segment = points(i,:);
        line([current_segment(1) current_segment(1);], [extrema(1) extrema(2)], 'Color', 'red')
        line([current_segment(2) current_segment(2);], [extrema(1) extrema(2)], 'Color', 'red')
    end
    
%     points = get_event_times(cells(:,2));
%     for i = 1:length(points)
%         current_segment = points(i,:);
%         line([current_segment(1) current_segment(1)], [extrema(1) extrema(2)], 'Color', 'green')
%         line([current_segment(2) current_segment(2)], [extrema(1) extrema(2)], 'Color', 'green')
%     end
%     
%     points = get_event_times(cells(:,3));
%     for i = 1:length(points)
%         current_segment = points(i,:);
%         line([current_segment(1) current_segment(1)], [extrema(1) extrema(2)], 'Color', 'black')
%         line([current_segment(2) current_segment(2)], [extrema(1) extrema(2)], 'Color', 'black')
%     end
%     current_segment = bc_segment;
%     line([current_segment(1) current_segment(1)], [extrema(1) extrema(2)], 'Color', 'magenta')
%     line([current_segment(2) current_segment(2)], [extrema(1) extrema(2)], 'Color', 'magenta')
end