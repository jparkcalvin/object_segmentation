% input: superpixel_class (1 x num_images cell)
%        MRF_label (1 x num_images cell)
%        im_size (num_images x 2 double)
%        num_images
%        num_class
% output: confusion_matrix (num_class x num_class double)
%         pixel_accuracy
%         class_accuracy

function [confusion_matrix, pixel_accuracy, class_accuracy] = getResult(superpixel_class, MRF_label, num_images, num_class)
confusion_matrix = zeros(num_class);
pixel_accuracy_n = 0;
pixel_accuracy_d = 0;
imageClass = {'grass', 'cow', 'tree', 'building', 'sky', 'airplane', 'face', 'car', 'bicycle'};
for i = 1:num_images
    num_superpixel = length(superpixel_class{i});
    
    for j = 1:num_superpixel
        a = superpixel_class{i}(j);
        b = MRF_label{i}(j);
        if a == 0 || b == 0
            continue
        end
        
        if a == b
            confusion_matrix(a, a) = confusion_matrix(a, a) + 1;
            pixel_accuracy_n = pixel_accuracy_n + 1;
        else
            confusion_matrix(a, b) = confusion_matrix(a, b) + 1;
            pixel_accuracy_d = pixel_accuracy_d + 1;
        end
    end    
end

pixel_accuracy = pixel_accuracy_n / (pixel_accuracy_d + pixel_accuracy_n);

class_accuracy_mat = zeros(num_class , 1);

for i = 1:num_class
    confusion_matrix(i,:) = confusion_matrix(i,:) / sum(confusion_matrix(i,:));
    class_accuracy_mat(i) = confusion_matrix(i,i);
end

class_accuracy = mean(class_accuracy_mat);

% draw confusion matrix
imagesc(confusion_matrix);
set(gca,'XTickLabel',imageClass);
set(gca,'YTickLabel',imageClass);
colorbar;


end