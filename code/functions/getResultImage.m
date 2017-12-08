% input: segmnets (1 x num_images cell)
%        MRF_label (1 x num_images cell)
%        im_size (num_images x 2 double)
%        num_images
%        num_class
% output: resultImages (1 x num_images cell)

function [resultImages] = getResultImage(segments, MRF_label, im_size, num_images, num_class)
% object classes
% 1: grass / 2: cow / 3: tree / 4: building / 5: sky / 6: airplane
% 7: face / 8: car / 9: bicycle

imageClass = cell(1, num_class);
imageClass{1} = uint8([ 0  128  0]);
imageClass{2} = uint8([ 0   0  128]);
imageClass{3} = uint8([128 128  0]);
imageClass{4} = uint8([128  0   0]);
imageClass{5} = uint8([128 128 128]);
imageClass{6} = uint8([192  0   0]);
imageClass{7} = uint8([192 128  0]);
imageClass{8} = uint8([ 64  0  128]);
imageClass{9} = uint8([192  0  128]);

resultImages = cell(1,num_images);

for i = 1:num_images
    num_superpixel = length(unique(segments{i}));
    idx = unique(segments{i});
    resultImages{i} = zeros(im_size(i,1),im_size(i,2),3, 'uint8');
    
    for j = 1:im_size(i,1)
        for k = 1:im_size(i,2)
            for n = 1:num_superpixel
                if segments{i}(j,k) == idx(n)
                    resultImages{i}(j,k,:) = imageClass{MRF_label{i}(n,1)};                    
                end
            end
        end
    end
end

end