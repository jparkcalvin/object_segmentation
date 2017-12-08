% input: hist_training (1 x num_images cell)
%        class_training (1 x num_images cell)
%        num_images
%        num_class
% output: bow_hist (1 x num_class cell)

function [bow_hist] = makeBOW(hist_training, class_training, num_images, num_class)

bow_hist = cell(1, num_class);

for i = 1:num_images
    
    num_superpixel = length(hist_training{i});
    
    for j = 1:num_superpixel
        for k = 1:num_class
            if class_training{i}(j) == k
                bow_hist{k} = [bow_hist{k} hist_training{i}{j}];
            end
        end 
    end
    
end

end