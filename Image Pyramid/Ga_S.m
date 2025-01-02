% Gaussian Pyramid - Save Outputs for Downsampling and Reconstruction with 2^k Scaling

% Read and convert to grayscale
input_image = 'UCSB.jpeg'; % Replace with your image file
img = imread(input_image);
if size(img, 3) == 3
    img = rgb2gray(img); % Convert to grayscale if the image is RGB
end
img = double(img); % Convert to double for processing

% Parameters
sigma = 1.5; % Bandwidth (standard deviation)
interp_method = 'bicubic'; % Interpolation method

% Downsampling and Upsampling Factors
levels = [1, 2, 3]; % Corresponding to 2^1, 2^2, 2^3

for k = levels
    factor = 2^k; % Downsampling/Upsampling factor

    % Construct (Downsampling)
    smoothed = imgaussfilt(img, sigma); % Apply Gaussian smoothing
    downsampled = smoothed(1:factor:end, 1:factor:end); % Downsample by factor

    % Reconstruct (Upsampling and Filtering)
    upsampled = imresize(downsampled, factor, interp_method); % Upsample by 2^k
    reconstructed = imgaussfilt(upsampled, sigma); % Apply Gaussian filtering

    % Resize to match original size
    reconstructed_resized = imresize(reconstructed, size(img), interp_method);

    % Save Images
    imwrite(uint8(downsampled), sprintf('downsampled_image_gaussian_factor_%d.png', factor)); % Save the downsampled image
    imwrite(uint8(reconstructed_resized), sprintf('reconstructed_image_gaussian_factor_%d.png', factor)); % Save the reconstructed image

    % Calculate SSIM
    ssim_value = ssim(uint8(reconstructed_resized), uint8(img));
    fprintf('SSIM for Gaussian Pyramid with downsampling factor=%d: %.4f\n', factor, ssim_value);
end
