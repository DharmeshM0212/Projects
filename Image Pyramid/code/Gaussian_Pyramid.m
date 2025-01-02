% Load an image
img = imread("C:/Users/DHARMESH M/Documents/MATLAB/Pyramid Projects/UCSB.jpeg"); % Replace with your image path
if size(img, 3) == 3
    gray_img = rgb2gray(img); % Convert to grayscale if image is RGB
else
    gray_img = img;
end

% Display the original image
figure;
imshow(gray_img);
title('Original Image');

% Downsampling factor
scale = 0.5; % Reduce size by half

% 1. Nearest-Neighbor Interpolation
down_nearest = imresize(gray_img, scale, 'nearest');
up_nearest = imresize(down_nearest, size(gray_img), 'nearest');

% 2. Bilinear Interpolation
down_bilinear = imresize(gray_img, scale, 'bilinear');
up_bilinear = imresize(down_bilinear, size(gray_img), 'bilinear');

% 3. Bicubic Interpolation
down_bicubic = imresize(gray_img, scale, 'bicubic');
up_bicubic = imresize(down_bicubic, size(gray_img), 'bicubic');

% Calculate SSIM for each method
[ssim_nearest, ~] = ssim(up_nearest, gray_img);
[ssim_bilinear, ~] = ssim(up_bilinear, gray_img);
[ssim_bicubic, ~] = ssim(up_bicubic, gray_img);

% Display SSIM values
fprintf('SSIM for Nearest-Neighbor: %.4f\n', ssim_nearest);
fprintf('SSIM for Bilinear: %.4f\n', ssim_bilinear);
fprintf('SSIM for Bicubic: %.4f\n', ssim_bicubic);

% Visualize the reconstructed images
figure;
subplot(1, 3, 1);
imshow(up_nearest);
title('Reconstructed (Nearest)');

subplot(1, 3, 2);
imshow(up_bilinear);
title('Reconstructed (Bilinear)');

subplot(1, 3, 3);
imshow(up_bicubic);
title('Reconstructed (Bicubic)');
