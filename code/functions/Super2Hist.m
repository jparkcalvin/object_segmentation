% input: segments (1 x num_images cell)
%        superpixel_images (1 x num_images cell)
%        nearest_words (1 x num_images cell)
%        im_size (num_images x 2 double)
%        num_images
%        num_cluster
% output: superpixel_histogram (1 x num_images cell)

function [superpixel_histogram] = Super2Hist(segments, superpixel_images, nearest_words, im_size, num_images, num_cluster)

for i = 1:num_images
    for j = 1:im_size(i,1)
        for k = 1:im_size(i,2)
            if superpixel_images{i}(j,k) == 0
                nearest_words{i}(j,k) = 0;
            end
        end
    end
end

superpixel_histogram = cell(1,num_images);

for i = 1:num_images
    
    num_superpixel = length(unique(segments{i}));
    superpixel_histogram{i} = cell(1,num_superpixel);
    
    for l = 0:num_superpixel-1
        superpixel_histogram{i}{l+1} = [];
        
        for j = 1:im_size(i,1)
            for k = 1:im_size(i,2)
                if segments{i}(j,k) == l
                    superpixel_histogram{i}{l+1} = [superpixel_histogram{i}{l+1}; nearest_words{i}(j,k)];
                end
            end
        end
        
        h = histcounts(superpixel_histogram{i}{l+1}, num_cluster, 'Normalization', 'probability');            
        superpixel_histogram{i}{l+1} = h';
        
     end
     
end

end