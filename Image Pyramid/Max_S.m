% Max-Averaging Pyramid - Save Outputs for Multiples of 2 Analysis

% Read and convert to grayscale
input_image = 'UCSB.jpeg'; % Replace with your image file
img = imread(input_image);
if size(img, 3) == 3
    img = rgb2gray(img); % Convert to grayscale if the image is RGB
end
img = double(img); % Convert to double for processing

% Parameters
interp_method = 'bicubic'; % Interpolation method
alpha = 0.5; % Weight for max-averaging

% Downsampling and Upsampling Factors
levels = [1, 2, 3]; % Corresponding to 2^1, 2^2, 2^3

for k = levels
    factor = 2^k; % Downsampling/Upsampling factor

    % Construct (Downsampling)
    downsampled_max = blockproc(img, [factor, factor], @(block) max(block.data(:)));
    downsampled_avg = blockproc(img, [factor, factor], @(block) mean(block.data(:)));
    downsampled = alpha * downsampled_max + (1 - alpha) * downsampled_avg;

    % Reconstruct (Upsampling)
    upsampled = imresize(downsampled, factor, interp_method);

    % Resize to match original size
    reconstructed_resized = imresize(upsampled, size(img), interp_method);

    % Save Images
    imwrite(uint8(downsampled), sprintf('downsampled_image_max_averaging_factor_%d.png', factor)); % Save the downsampled image
    imwrite(uint8(reconstructed_resized), sprintf('reconstructed_image_max_averaging_factor_%d.png', factor)); % Save the reconstructed image

    % Calculate SSIM
    ssim_value = ssim(uint8(reconstructed_resized), uint8(img));
    fprintf('SSIM for Max-Averaging Pyramid with downsampling factor=%d: %.4f\n', factor, ssim_value);
end
