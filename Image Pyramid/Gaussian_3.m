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
current_img = gray_img; % Initialize current image for pyramid processing

% Step 1: Create Gaussian Pyramid (Downsampling Process)
for level = 1:levels
    % Apply Gaussian filtering
    blurred_img = imgaussfilt(current_img, sigma);
    
    % Downsample the image
    downsampled_img = imresize(blurred_img, 0.5, 'bicubic');
    downsampled_images{level} = downsampled_img; % Store downsampled image
    
    % Update current image for the next level
    current_img = downsampled_img;
end

% Step 2: Reconstruct the Pyramid (Upsampling Process)
reconstructed_img = downsampled_images{levels}; % Start from the smallest image
for level = levels:-1:1
    % Upsample to the size of the previous level
    reconstructed_img = imresize(reconstructed_img, size(gray_img), 'bicubic');
end

% Step 3: Check Dimensions
if ~isequal(size(gray_img), size(reconstructed_img))
    error('Dimensions of the original and reconstructed images do not match!');
end

% Normalize images to [0, 1] for SSIM/MS-SSIM
original_img = mat2gray(gray_img); % Original image normalized
reconstructed_img = mat2gray(reconstructed_img); % Final reconstructed image normalized

% Step 4: Compute SSIM
ssim_value = ssim(reconstructed_img, original_img);
disp(['SSIM (Original vs. Final Reconstructed): ', num2str(ssim_value)]);

% Step 5: Compute MS-SSIM (if multissim is available)
if exist('multissim', 'file') == 2
    [ms_ssim_value, ~] = multissim(original_img, reconstructed_img);
    disp(['MS-SSIM (Original vs. Final Reconstructed): ', num2str(ms_ssim_value)]);
else
    disp('MS-SSIM calculation requires the Image Processing Toolbox with multissim.');
end

% Step 6: Visualize Original, Downsampled, and Reconstructed Images
figure;

% Display original image
subplot(1, levels + 2, 1);
imshow(uint8(gray_img));
title('Original Image');

% Display downsampled images for each level
for level = 1:levels
    subplot(1, levels + 2, level + 1);
    imshow(uint8(downsampled_images{level}));
    title(['Downsampled (Level ', num2str(level), ')']);
end

% Display final reconstructed image
subplot(1, levels + 2, levels + 2);
imshow(uint8(reconstructed_img * 255)); % Convert normalized image for display
title('Reconstructed Image');
