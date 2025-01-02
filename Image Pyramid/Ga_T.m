% Gaussian Pyramid - Time and Memory Analysis with Image Saving

% Read and convert to grayscale
input_image = 'leena.jpeg'; % Replace with your image file
img = imread(input_image);
if size(img, 3) == 3
    img = rgb2gray(img); % Convert to grayscale if the image is RGB
end
img = double(img); % Convert to double for processing

% Parameters
sigma = 1.5; % Standard deviation for Gaussian smoothing
interp_method = 'bicubic';

% Measure Time for Construction
tic;
smoothed = imgaussfilt(img, sigma); % Gaussian smoothing
downsampled = smoothed(1:2:end, 1:2:end); % Downsample by 2
time_downsampling = toc;

% Measure Time for Reconstruction
tic;
upsampled = imresize(downsampled, 2, interp_method); % Upsample by 2
reconstructed = imgaussfilt(upsampled, sigma); % Apply Gaussian filtering
time_reconstruction = toc;

% Measure Memory Usage
vars = whos;
memory_usage = sum([vars.bytes]) / 1e6; % Total memory in MB

% Save Images
imwrite(uint8(img), 'gaussian_original_imageT.png'); % Save original image
imwrite(uint8(downsampled), 'gaussian_downsampled_imageT.png'); % Save downsampled image
imwrite(uint8(reconstructed), 'gaussian_reconstructed_imageT.png'); % Save reconstructed image

% Display Results
fprintf('Gaussian Pyramid:\n');
fprintf('Time for Downsampling: %.4f seconds\n', time_downsampling);
fprintf('Time for Reconstruction: %.4f seconds\n', time_reconstruction);
fprintf('Memory Usage: %.2f MB\n', memory_usage);
