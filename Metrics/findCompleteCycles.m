function [ complete_cycles ] = findCompleteCycles( classes, nPhases )
% Takes the output of the classifier and returns complete gait cycles as a
% matrix where each row contains the frame indexes of a full gait cycle.

next_class = 0;
current_cycle = [];
complete_cycles = [];
for i=1 : length(classes)
    if classes(i) == next_class + 1;
        current_cycle = [current_cycle i];
        next_class = mod(next_class + 1, nPhases);
        if next_class == 0
            complete_cycles = [complete_cycles; current_cycle];
            current_cycle = [];
        end
    elseif classes(i) ~= next_class
        current_cycle = [];
    end
    
end

end

