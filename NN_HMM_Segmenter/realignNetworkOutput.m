function [ classes ] = realignNetworkOutput( windows, step_size, window_size, length_of_original_input )
% Takes output classifications of sliding window neural network and realigns
% with original input.

% Assumes that sliding windows were classified based on their central
% index.

classes = zeros(1, length_of_original_input);

for i = 1 : length(windows)
    original_index = (i-1)*step_size+floor(window_size/2)+1;
    class = vec2ind(windows(:,i));
    classes(original_index) = class;
end

end