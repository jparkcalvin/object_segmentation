% refered by https://stackoverflow.com/questions/23419208/view-vl-slic-output-matlab

% input: im (im_size(1) x im_size(2) x 3 uint8)
%        segments (im_size(1) x im_size(2) uint32)
% output: contour (im_size(1) x im_size(2) x 3 uint8)
%         neighbor_superpixel (1 x num_superpixel cell)

function [contour, neighbor_superpixel] = makeContour(im, segments)

[im_row, im_col, ~] = size(im);

contour = im;
num_superpixel = length(unique(segments));
idx = unique(segments);
neighbor_superpixel = cell(1, num_superpixel);

for i = 1:num_superpixel
    neighbor_superpixel{i} = [];
end

for i = 1:im_row
    for j = 1:im_col
        segment = segments(i,j);             
        segment_top    = 0;
        segment_bottom = 0;
        segment_left   = 0;
        segment_right  = 0;
        seg_idx = find(idx == segment);
        
        if i > 1
            segment_top = segments(i-1,j);
        end
        if j > 1
            segment_left = segments(i,j-1);
        end
        if i < im_row
            segment_bottom = segments(i+1,j);
        end
        if j < im_col
            segment_right = segments(i,j+1);
        end
        
        if segment_top ~= 0 && segment_top ~= segment
            contour(i, j, 1) = 0;
            contour(i, j, 2) = 0;
            contour(i, j, 3) = 0;
            neighbor_superpixel{seg_idx} = [neighbor_superpixel{seg_idx}; find(idx == segment_top)];
        elseif segment_left ~= 0 && segment_left ~= segment
            contour(i, j, 1) = 0;
            contour(i, j, 2) = 0;
            contour(i, j, 3) = 0;
            neighbor_superpixel{seg_idx} = [neighbor_superpixel{seg_idx}; find(idx == segment_left)];
        elseif segment_bottom ~= 0 && segment_bottom ~= segment
            contour(i, j, 1) = 0;
            contour(i, j, 2) = 0;
            contour(i, j, 3) = 0;
            neighbor_superpixel{seg_idx} = [neighbor_superpixel{seg_idx}; find(idx == segment_bottom)];
        elseif segment_right ~= 0 && segment_right ~= segment
            contour(i, j, 1) = 0;
            contour(i, j, 2) = 0;
            contour(i, j, 3) = 0;
            neighbor_superpixel{seg_idx} = [neighbor_superpixel{seg_idx}; find(idx == segment_right)];           
        end
    end
end

for i = 1:num_superpixel
    neighbor_superpixel{i} = unique(neighbor_superpixel{i});
end
end