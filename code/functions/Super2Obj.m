% input: segments (1 x num_images cell)
%        superpixel_images (1 x num_images cell)
%        images_GT (1 x num_images cell)
%        im_size (num_images x 2 double)
%        num_class
% output: superpixel_object (1 x num_images cell)

function [superpixel_object] = Super2Obj(segments, superpixel_images, images_GT, im_size, num_class)
% object classes
% 1: grass / 2: cow / 3: tree / 4: building / 5: sky / 6: airplane
% 7: face / 8: car / 9: bicycle

imageClass = cell(1, num_class);
imageClass{1} = [ 0  128  0];
imageClass{2} = [ 0   0  128];
imageClass{3} = [128 128  0];
imageClass{4} = [128  0   0];
imageClass{5} = [128 128 128];
imageClass{6} = [192  0   0];
imageClass{7} = [192 128  0];
imageClass{8} = [ 64  0  128];
imageClass{9} = [192  0  128];

num_images = 120;

for i = 1:num_images
    for j = 1:im_size(i,1)
        for k = 1:im_size(i,2)
            if superpixel_images{i}(j,k) == 0
                images_GT{i}(j,k) = 0;
            end
        end
    end
end

superpixel_object_feature = cell(1,num_images);
superpixel_object = cell(1,num_images);

for i = 1:num_images
    
    num_superpixel = length(unique(segments{i}));
    superpixel_object_feature{i} = cell(1, num_superpixel);
    superpixel_object{i} = zeros(num_superpixel, 1);
    
    for l = 0:num_superpixel-1
        superpixel_object_feature{i}{l+1} = [];
        
        for j = 1:im_size(i,1)
            for k = 1:im_size(i,2)
                if segments{i}(j,k) == l
                    superpixel_object_feature{i}{l+1} = [superpixel_object_feature{i}{l+1}; images_GT{i}(j,k,1) images_GT{i}(j,k,2) images_GT{i}(j,k,3)];
                end
            end
        end
               
        superpixel_object_feature{i}{l+1} = mode(superpixel_object_feature{i}{l+1});
        
        for n = 1:num_class
            if superpixel_object_feature{i}{l+1} == imageClass{n}
                superpixel_object{i}(l+1) = n;
            end
        end
     end
     
end

end