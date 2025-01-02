% Read the input image
img = imread('C:/Users/DHARMESH M/Documents/MATLAB/Pyramid Projects/UCSB.jpeg'); % Replace with your image file
if size(img, 3) == 3
    img = rgb2gray(img); % Convert to grayscale if the image is RGB
end

% Convert image to double precision
img = im2double(img);

% Define block size
block_size = 2; % Block size (e.g., 2x2)

% Get image size
[rows, cols] = size(img);

% Ensure dimensions are divisible by block size
rows = floor(rows / block_size) * block_size;
cols = floor(cols / block_size) * block_size;
img = img(1:rows, 1:cols);

% Step 1: Downsampling using Max and Average pooling
max_pooled_img = zeros(rows / block_size, cols / block_size);
avg_pooled_img = zeros(rows / block_size, cols / block_size);

% Compute max and average pooling
for i = 1:block_size:rows
    for j = 1:block_size:cols
        block = img(i:i+block_size-1, j:j+block_size-1);
        max_pooled_img((i-1)/block_size+1, (j-1)/block_size+1) = max(block(:));
        avg_pooled_img((i-1)/block_size+1, (j-1)/block_size+1) = mean(block(:));
    end
end

% Combine max and average results
alpha = 0.5; % Weighting factor
downsampled_img = alpha * max_pooled_img + (1 - alpha) * avg_pooled_img;

% Step 2: Upsampling back to original size
upsampled_img = imresize(downsampled_img, size(img), 'bicubic');

% Step 3: Display the images
figure;
tiledlayout(1, 3, 'TileSpacing', 'compact');

% Original Image
nexttile;
imshow(img);
title('Original Image');
xlabel(['Size: ', num2str(size(img, 1)), 'x', num2str(size(img, 2))]);

% Downsampled Image
nexttile;
imshow(downsampled_img, []);
title('Downsampled Image (Max-Averaging)');
xlabel(['Size: ', num2str(size(downsampled_img, 1)), 'x', num2str(size(downsampled_img, 2))]);

% Reconstructed Image
nexttile;
imshow(upsampled_img, []);
title('Reconstructed Image (Max-Averaging)');
xlabel(['Size: ', num2str(size(upsampled_img, 1)), 'x', num2str(size(upsampled_img, 2))]);

% Step 4: Calculate SSIM
ssim_val = ssim(upsampled_img, img);
fprintf('SSIM between original and reconstructed image: %.4f\n', ssim_val);
