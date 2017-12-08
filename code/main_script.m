%% Initialization
clc;
clear;

run('vlfeat-0.9.20-bin/vlfeat-0.9.20/toolbox/vl_setup')
addpath('gco-v3.0/matlab')

%% Settings
% object classes
imageclass = {'grass', 'cow', 'tree', 'building', 'sky', 'airplane', 'face', 'car', 'bicycle'};
num_class = length(imageclass);

% image information
[trainingImages, training_im_size] = getTrainingImages;
trainingImages_GT = getTrainingImagesGT;
[testImages, test_im_size] = getTestImages;
testImages_GT = getTestImagesGT;
num_trainingImages = 120;
num_testImages = 120;

%% Constructing dictionary using Texton features of training images
% creating a filter bank
filter_size = [200 200];  % a filter size of the filter bank
F = makeFilterbank(filter_size);

% obtain texton features of training images
texton_features_training = cell(1, num_trainingImages);
features_trainingImages = [];
for i = 1:num_trainingImages
    texton_features_training{i} = obtainTexton(trainingImages{i}, training_im_size(i,:), F);
    features_trainingImages = [features_trainingImages; texton_features_training{i}];
end

% obtain texton features of test images
texton_features_test = cell(1, num_testImages);
for i = 1:num_testImages
    texton_features_test{i} = obtainTexton(testImages{i}, test_im_size(i,:), F);
end

K = 100;                % the number of clusters
[visual_centroids, visual_words] = vl_kmeans(features_trainingImages', K); 
visual_centroids = visual_centroids';
visual_words = visual_words';

%% Superpiexel representation
% superpixel settings
regionSize = 40;
regularizer = 0.2;  

% get superpixels of training images and test images
[superpixel_trainingImages, segments_trainingImages, neighbor_superpixel_training] = makeSuperpixel(trainingImages, regionSize, regularizer, num_trainingImages);
[superpixel_testImages, segments_testImages, neighbor_superpixel_test] = makeSuperpixel(testImages, regionSize, regularizer, num_testImages);

%% BoW representation
% for time-saving, load the data file
% but if K changes, it needs to be run again
nearest_words_trainingImages = findNearest(texton_features_training, training_im_size, visual_centroids, num_trainingImages, K);
nearest_words_testImages = findNearest(texton_features_test, test_im_size, visual_centroids, num_testImages, K);

% get histogram for each superpixel (both training and test images)
superpixel_histogram_training = Super2Hist(segments_trainingImages, superpixel_trainingImages, nearest_words_trainingImages, training_im_size, num_trainingImages, K);
superpixel_histogram_test = Super2Hist(segments_testImages, superpixel_testImages, nearest_words_testImages, test_im_size, num_testImages, K);

%% Make object class using ground truth
% allocate the object class to each superpixel
superpixel_class_training = Super2Obj(segments_trainingImages, superpixel_trainingImages, trainingImages_GT, training_im_size, num_class);
superpixel_class_test = Super2Obj(segments_testImages, superpixel_testImages, testImages_GT, test_im_size, num_class);


% organize histogram for each object class
class_hist_training = makeBOW(superpixel_histogram_training, superpixel_class_training, num_trainingImages, num_class);

%% MRF formulation

[MRF_testingImages, MRF_testImages_opt, MRF_testImages_label] = getMRF(superpixel_histogram_test, superpixel_class_test, class_hist_training, neighbor_superpixel_test, num_testImages, num_class, K);

%% Display and Evaluate the results

result_testImages =  getResultImage(segments_testImages, MRF_testImages_label, test_im_size, num_testImages, num_class);

[confusion_testImages, pixel_acc_testImages, class_acc_testImages] = getResult(superpixel_class_test, MRF_testImages_label, num_testImages, num_class);