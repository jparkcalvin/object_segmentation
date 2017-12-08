% input: texton_features (1 x num_images cell)
%        im_size (num_images x 2 double),
%        visual_centroids (num_cluster x num_feature double)
%        num_images
%        num_cluster
% output: nearest_visual_words (1 x num_images cell)

function [nearest_visual_words] = findNearest(texton_features, im_size, visual_centroids, num_images, num_cluster)

size_image = length(texton_features{1}(:,1));

nearest_visual_words = cell(1, num_images);

for i = 1:num_images
    V = zeros(size_image, 1);
    
    for j = 1:size_image
        distance = zeros(num_cluster, 1);
        
        for k = 1:num_cluster
            distance(k) = norm(texton_features{i}(j,:) - visual_centroids(k,:));
        end
        
        [~, m_index] = min(distance);
        V(j) = m_index;
    end
    
    nearest_visual_words{i} = reshape(V, im_size(i,1), im_size(i,2));
    
end

end