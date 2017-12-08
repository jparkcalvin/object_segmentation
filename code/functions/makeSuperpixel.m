% input: images (1 x num_images cell)
%        regionSize (1 x 1 double)
%        regularizer (1 x 1 double)
%        num_images
% output: superpixel_images (1 x num_images cell)
%         segments (1 x num_images cell)
%         neighbor_superpixels (1 x num_images cell)

function [superpixel_images, segments, neighbor_superpixels] = makeSuperpixel(images, regionSize, regularizer, num_images)

segments = cell(1, num_images);
superpixel_images = cell(1, num_images);
neighbor_superpixels = cell(1, num_images);

for i = 1:num_images
    segments{i} = vl_slic(single(im2double(images{i})), regionSize, regularizer);
    [superpixel_images{i}, neighbor_superpixels{i}] = makeContour(images{i}, segments{i});
end

end