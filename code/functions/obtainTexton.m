% input: im (im_size(1) x im_size(2) x 3 uint8)
%        im_size (num_images x 2 double)
%        filterbank (1 x num_filter)
% output: textonFeatures (im_size(1)*im_size(2) x num_feature double) 

function [textonFeatures] = obtainTexton(im, im_size, filterbank)

num_feature = 17; % Gaussian: l, a, b channels / LoG and DoG: l channel

im = im2double(im);
im_lab = rgb2lab(im);
im_l = im_lab(:,:,1);
im_a = im_lab(:,:,2);
im_b = im_lab(:,:,3);

A{1} = conv2(im_l,filterbank{1,1},'same');
A{2} = conv2(im_a,filterbank{1,1},'same');
A{3} = conv2(im_b,filterbank{1,1},'same');
A{4} = conv2(im_l,filterbank{1,2},'same');
A{5} = conv2(im_a,filterbank{1,2},'same');
A{6} = conv2(im_b,filterbank{1,2},'same');
A{7} = conv2(im_l,filterbank{1,3},'same');
A{8} = conv2(im_a,filterbank{1,3},'same');
A{9} = conv2(im_b,filterbank{1,3},'same');
A{10} = conv2(im_l,filterbank{1,4},'same');
A{11} = conv2(im_l,filterbank{1,5},'same');
A{12} = conv2(im_l,filterbank{1,6},'same');
A{13} = conv2(im_l,filterbank{1,7},'same');
A{14} = conv2(im_l,filterbank{1,8},'same');
A{15} = conv2(im_l,filterbank{1,9},'same');
A{16} = conv2(im_l,filterbank{1,10},'same');
A{17} = conv2(im_l,filterbank{1,11},'same');

V = zeros(im_size(1) * im_size(2), num_feature);

for i = 1:num_feature
    feature_vector = A{1,i}(:);
    feature_vector = feature_vector - mean(feature_vector);
    feature_vector = feature_vector / std(feature_vector(:));
    V(:,i) = feature_vector;
end

textonFeatures = V;

end