% input: filter_size (A x A double)
% output: F (1 x num_filter cell) 

function [F] = makeFilterbank(filter_size)

% constants
num_filter = 11;
sigma_G = [1 2 4];
sigma_LoG = [1 2 4 8];
sigma_DoG = [2 4];

% 3 Gaussians with sigma = 1, 2, 4
h_G1 = fspecial('gaussian', filter_size, sigma_G(1));
h_G2 = fspecial('gaussian', filter_size, sigma_G(2));
h_G3 = fspecial('gaussian', filter_size, sigma_G(3));

% 4 Laplacian of Gaussians (LoG)
h_LoG1 = fspecial('log', filter_size, sigma_LoG(1));
h_LoG2 = fspecial('log', filter_size, sigma_LoG(2));
h_LoG3 = fspecial('log', filter_size, sigma_LoG(3));
h_LoG4 = fspecial('log', filter_size, sigma_LoG(4));

% 4 Derivative of Gaussians (DoG)
h_DoG1 = fspecial('gaussian', filter_size, sigma_DoG(1));
h_DoG2 = fspecial('gaussian', filter_size, sigma_DoG(2));
[h_DoG1x, h_DoG1y] = gradient(h_DoG1);
[h_DoG2x, h_DoG2y] = gradient(h_DoG2);

filter{1,1} =   h_G1; 
filter{1,2} =   h_G2;
filter{1,3} =   h_G3;
filter{1,4} =   h_LoG1;
filter{1,5} =   h_LoG2;
filter{1,6} =   h_LoG3;
filter{1,7} =   h_LoG4;
filter{1,8} =   h_DoG1x;
filter{1,9} =   h_DoG1y;
filter{1,10} =   h_DoG2x;
filter{1,11} =   h_DoG2y;


% Visualize the filters
hFig1 = figure(1);
set(hFig1, 'Position', [160 140 1600 800])

for i = 1:num_filter
    if (i < 4)
    subplot(3,4,i)
    imagesc(filter{1,i});
    end
    if (i >= 4)
    subplot(3,4,i+1)
    imagesc(filter{1,i});
    end
end

F = filter;

end