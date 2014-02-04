function [ X, T ] = formatForNetwork_old(walk_data, segments, step_size, window_size)
%UNTITLED3 Creates data structure for input to neural network.
%   Returns a matrix where each column has the data from a sliding
%   window over the input walk.
%
%   segments - a matrix where each column contains a
%   separate full step, and within each column the segments are in order of
%   heel up; toe off; heel strike; toe down.
%
%   walk_data - as imported by loadWalk.m
    
    input_size = size(walk_data);
    X = zeros(window_size * input_size(2), ceil((length(walk_data)-window_size+1)/step_size));
    T = zeros(4, ceil((length(walk_data)-window_size+1)/step_size));

    i = 0;
    while i*step_size + window_size <= length(walk_data)
        window_data = walk_data((i*step_size)+1:(i*step_size)+window_size, :);
        X(:,i+1) = reshape(window_data, numel(window_data), 1);
        T(:,i+1) = findClassAtCentreOfWindow(i*step_size+1, window_size, segments);
        i = i + 1;
    end

end

function class = findClassAtCentreOfWindow(window_start_index, window_size, segments)

    index_of_centre = window_start_index + floor(window_size/2);
    
    % Find the segment prior to the index, and use that class
    if index_of_centre < min(min(segments))
        prior_segment = 0;
    elseif index_of_centre >= max(max(segments))
        prior_segment = numel(segments);
    else
        for i = 1 : numel(segments)
            if segments(i) > index_of_centre
                prior_segment = i-1;
                break
            end
        end
    end
    
    prior_segment_class = mod(prior_segment,4)+1;
    class = zeros(4,1);
    class( prior_segment_class ) = 1;
end