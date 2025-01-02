% Gaussian Pyramid - Save Bicubic Interpolation Output

% Read and convert to grayscale
input_image = 'UCSB.jpeg'; % Specify your image file
img = imread(input_image);
if size(img, 3) == 3
    img = rgb2gray(img); % Convert to grayscale if the image is RGB
end
img = double(img); % Convert to double for processing

% Parameters
sigma = 1.5; % Standard deviation for Gaussian smoothing

% Construct (Downsampling)
smoothed = imgaussfilt(img, sigma); % Apply Gaussian smoothing
downsampled = smoothed(1:2:end, 1:2:end); % Downsample by retaining alternate rows and columns

% Bicubic Interpolation for Reconstruction
upsampled = imresize(downsampled, 2, 'bicubic'); % Upsample with bicubic interpolation
reconstructed = imgaussfilt(upsampled, sigma); % Apply Gaussian filtering

% Resize to match original size using bicubic interpolation
reconstructed_resized = imresize(reconstructed, size(img), 'bicubic'); % Ensure size match

% Save Images
imwrite(uint8(img), 'original_image_gaussian_bicubic.png'); % Save the original image
imwrite(uint8(downsampled), 'downsampled_image_gaussian_bicubic.png'); % Save the downsampled image
imwrite(uint8(reconstructed_resized), 'reconstructed_image_gaussian_bicubic.png'); % Save the reconstructed image

% Display SSIM Value
ssim_value = ssim(uint8(reconstructed_resized), uint8(img)); % Compute SSIM
disp(['SSIM for Gaussian Pyramid with bicubic interpolation: ', num2str(ssim_value)]);
