% input: hist_images (1 x num_images cell)
%        class_images (1 x num_images cell)
%        class_hist (1 x num_class cell)
%        neighbor_superpixel (1 x num_images cell)
%        num_images 
%        num_class 
%        num_cluster
% output: MRF_initial (1 x num_images cell)
%         MRF_optimized (1 x num_images cell)
%         MRF_label (1 x num_images cell)

function [MRF_initial, MRF_optimized, MRF_label] = getMRF(hist_images, class_images, class_hist, neighbor_superpixel, num_images, num_class, num_cluster)

lambda = 0.01;       % constant for the pairwise potentials (Potts model)

MRF_initial = cell(1, num_images);
MRF_optimized = cell(1, num_images);
MRF_cost = cell(1, num_images);
MRF_potential = cell(1, num_images);
MRF_label = cell(1, num_images);

for i = 1:num_images
    num_superpixel = length(hist_images{i});
    MRF_initial{i} = cell(1, num_superpixel);
    MRF_cost{i} = cell(1, num_superpixel);
    MRF_potential{i} = cell(1, num_superpixel);
    
    for j = 1:num_superpixel
         MRF_cost{i}{j} = 0;
         class_BOW = class_images{i}(j);
         if class_BOW == 0
             MRF_initial{i}{j} = 1;
             continue;
         end
         
         % calculate chi-square distance (data cost)
         mean_class_hist = mean(class_hist{class_BOW}');
         for k = 1:num_cluster
             if mean_class_hist(k) + hist_images{i}{j}(k) ~= 0
                 MRF_cost{i}{j} = MRF_cost{i}{j} + (1/2) * ((mean_class_hist(k) - hist_images{i}{j}(k))^2)/(mean_class_hist(k) + hist_images{i}{j}(k));
             end
         end

         
        % calculate pairwise potentials (pairwise cost)
        MRF_potential{i}{j} = 0;
        num_neighbor_superpixel = length(neighbor_superpixel{i}{j});
         
        for k = 1:num_neighbor_superpixel
            if class_images{i}(j) ~= class_images{i}(neighbor_superpixel{i}{j}(k))
                MRF_potential{i}{j} = MRF_potential{i}{j} + lambda;
            end
        end
        
        MRF_initial{i}{j} = MRF_cost{i}{j} + MRF_potential{i}{j};
                
    end
    
    % get the optimized energy function using Graph Cut (using gco-v3.0)
    
    h = GCO_Create(num_superpixel, num_class);
    dataCost = zeros(num_class, num_superpixel);
    for j = 1:num_superpixel
        for k = 1:num_class
            mean_class_hist = mean(class_hist{k}'); 
            for n = 1:num_cluster
                if mean_class_hist(n) + hist_images{i}{j}(n) ~= 0
                    dataCost(k,j) = dataCost(k,j) + (1/2) * ((mean_class_hist(n) - hist_images{i}{j}(n))^2)/(mean_class_hist(n) + hist_images{i}{j}(n));
                end
            end
            if class_images{i}(j) == 0
                dataCost(k,j) = 1;
            end
        end        
    end
    dataCost = int32(dataCost*1000000);
    GCO_SetDataCost(h, dataCost);
    
    SmoothCost = zeros(num_class);
    for j = 1:num_class
        for k = 1:num_class
            if j ~= k
                SmoothCost(j,k) = lambda;
            end
        end
    end
    SmoothCost = int32(SmoothCost*1000000);
    GCO_SetSmoothCost(h, SmoothCost);
    
    Neighbors = zeros(num_superpixel);
    for j = 1:num_superpixel
        num_neighbor_superpixel = length(neighbor_superpixel{i}{j});
        for n = 1:num_neighbor_superpixel
            if neighbor_superpixel{i}{j}(n) > j
                Neighbors(j,neighbor_superpixel{i}{j}(n)) = 1;
            end
        end
    end
    GCO_SetNeighbors(h, Neighbors);
    
    GCO_Expansion(h);
    MRF_label{i} = GCO_GetLabeling(h);
    [MRF_optimized{i}, ~, ~] = GCO_ComputeEnergy(h);
    
    GCO_Delete(h);
end

end