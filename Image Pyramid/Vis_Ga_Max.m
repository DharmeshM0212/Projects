% Read the input image
img = imread('C:/Users/DHARMESH M/Documents/MATLAB/Pyramid Projects/UCSB.jpeg'); % Replace with your image file
if size(img, 3) == 3
    img = rgb2gray(img); % Convert to grayscale if the image is RGB
end

% Convert image to double precision
img = im2double(img);

% Define Gaussian filter
sigma = 1.6; % Standard deviation for Gaussian filter
gaussian_filter = fspecial('gaussian', [5, 5], sigma);

% Step 1: Gaussian filtering
blurred_img = imfilter(img, gaussian_filter, 'replicate');

% Step 2: Downsampling (ensure dimensions are divisible by 2)
downsampled_img = blurred_img(1:2:end, 1:2:end); % Take every 2nd row and column

% Step 3: Upsampling using imresize to match original size
upsampled_img = imresize(downsampled_img, size(img), 'bicubic'); % Interpolate to match original size

% Display images
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
title('Downsampled Image');
xlabel(['Size: ', num2str(size(downsampled_img, 1)), 'x', num2str(size(downsampled_img, 2))]);

% Reconstructed Image
nexttile;
imshow(upsampled_img, []);
title('Reconstructed Image');
xlabel(['Size: ', num2str(size(upsampled_img, 1)), 'x', num2str(size(upsampled_img, 2))]);

% Step 4: Calculate SSIM
ssim_val = ssim(upsampled_img, img);
fprintf('SSIM between original and reconstructed image: %.4f\n', ssim_val);

% Step 5: Calculate MS-SSIM
ms_ssim_val = multissim(upsampled_img, img);
fprintf('MS-SSIM between original and reconstructed image: %.4f\n', ms_ssim_val);
