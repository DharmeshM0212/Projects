% Gaussian Pyramid - 1 Level Construction and Reconstruction

% Read and convert to grayscale
input_image = 'UCSB.jpeg'; % Specify your image file
img = imread(input_image);
if size(img, 3) == 3
    img = rgb2gray(img); % Convert to grayscale if the image is RGB
end
img = double(img); % Convert to double for processing

% Parameters
sigma = 1.5; % Standard deviation for Gaussian smoothing

% Step 1: Construct (Downsampling using Gaussian Filter)
smoothed = imgaussfilt(img, sigma); % Apply Gaussian smoothing
downsampled = smoothed(1:2:end, 1:2:end); % Downsample by taking alternate rows and columns

% Step 2: Reconstruct (Upsampling and Filtering)
upsampled = imresize(downsampled, 2, 'bicubic'); % Upsample by a factor of 2 using bicubic interpolation
reconstructed_resized = imgaussfilt(upsampled, sigma); % Apply Gaussian filter after upsampling

% Step 3: Save Images
imwrite(uint8(img), 'original_image_gaussian.png'); % Save the original image
imwrite(uint8(downsampled), 'downsampled_image_gaussian.png'); % Save the downsampled image
imwrite(uint8(reconstructed_resized), 'reconstructed_image_gaussian.png'); % Save the reconstructed image

% Display SSIM Value
[ssim_value, ~] = ssim(uint8(reconstructed_resized), uint8(img)); % Compute SSIM
disp(['SSIM between Original and Reconstructed Image: ', num2str(ssim_value)]);
