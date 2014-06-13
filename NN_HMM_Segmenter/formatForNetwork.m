function [ X, T ] = formatForNetwork(walk_data, segments, step_size, window_size)
%formatForNetwork Creates data structure for input to neural network.
%   Returns a matrix where each column has the data from a sliding
%   window over the input walk.
%
%   segments - a 2xN matrix where each row contains a segment index and the
%   class of that segment.
%   MUST BE SORTED BY ASCENDING ORDER OF INDEX.
%   Segment classes should go from 1 to S.
%
%   walk_data - as imported by loadGyroWalks.m
    
    nClasses = max(segments(:,2));

    input_size = size(walk_data);
    X = zeros(window_size * input_size(2), ceil((length(walk_data)-window_size+1)/step_size));
    T = zeros(nClasses, ceil((length(walk_data)-window_size+1)/step_size));

    i = 0;
    minSeg = min(segments(:,1)); % Pre-computed
    maxSeg = max(segments(:,1)); % (for speed)
    while i*step_size + window_size <= length(walk_data)
        window_data = walk_data((i*step_size)+1:(i*step_size)+window_size, :);
        X(:,i+1) = reshape(window_data, numel(window_data), 1);
        T(findClassAtCentreOfWindow(i*step_size+1, window_size, segments, minSeg, maxSeg),i+1) = 1;
        i = i + 1;
    end

end

function window_class = findClassAtCentreOfWindow(window_start_index, window_size, segments, minSeg, maxSeg)
% Labels the window according to the class of its central index.

    index_of_centre = window_start_index + floor(window_size/2);
    
    % Find the segment prior to the index, and use that class
    if index_of_centre < minSeg
        next_segment = segments(1,:);
        prior_segment_class = mod( next_segment(2)-2, max(segments(:,2)) )+1;
        
    elseif index_of_centre >= maxSeg
        prior_segment_class = segments(end);
        
    else
        for i = 1 : length(segments)
            if segments(i,1) > index_of_centre
                prior_segment_class = segments(i-1,2);
                break
            end
        end
        
    end
    
    % Use vector representation for neural network.
    window_class = prior_segment_class;
end