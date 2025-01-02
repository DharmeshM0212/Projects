% Load the image
img = imread('C:/Users/DHARMESH M/Documents/MATLAB/Pyramid Projects/UCSB.jpeg'); % Replace with your image path
if size(img, 3) == 3
    gray_img = rgb2gray(img); % Convert to grayscale if the image is RGB
else
    gray_img = img;
end

% Convert to double for processing
gray_img = double(gray_img);

% Define parameters
levels = 3; % Number of pyramid levels
sigma = 1.6; % Gaussian blur parameter

% Initialize variables
downsampled_images = cell(1, levels); % Store downsampled images
ssim_values = zeros(1, levels); % Store SSIM values for each level

% Step 1: Create Gaussian Pyramid (Downsampling Process)
current_img = gray_img;
for level = 1:levels
    % Apply Gaussian filtering
    blurred_img = imgaussfilt(current_img, sigma);
    
    % Downsample the image
    downsampled_img = imresize(blurred_img, 0.5, 'bicubic');
    downsampled_images{level} = downsampled_img; % Store downsampled image
    
    % Update current image for the next level
    current_img = downsampled_img;
end

% Step 2: Reconstruct and Compare Each Level
for level = 1:levels
    % Reconstruct the image from the downsampled version at this level
    reconstructed_img = imresize(downsampled_images{level}, size(gray_img), 'bicubic');
    
    % Normalize images to [0, 1] for SSIM calculation
    input_img = mat2gray(gray_img); % Input image at this level
    reconstructed_img = mat2gray(reconstructed_img); % Reconstructed image
    
    % Compute SSIM
    ssim_values(level) = ssim(reconstructed_img, input_img);
end

% Display SSIM values
disp('SSIM values for Gaussian Pyramid - Per-Level Analysis:');
for level = 1:levels
    fprintf('Level %d: SSIM = %.4f\n', level, ssim_values(level));
end

% Plot SSIM values across levels
figure;
plot(1:levels, ssim_values, '-o', 'LineWidth', 2);
xlabel('Pyramid Level');
ylabel('SSIM');
title('SSIM Across Levels for Gaussian Pyramid');
grid on;
