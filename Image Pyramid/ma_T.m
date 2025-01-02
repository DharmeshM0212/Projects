% Max Pooling Pyramid - Time and Memory Analysis with Image Saving

% Read and convert to grayscale
input_image = 'leena.jpeg'; % Replace with your image file
img = imread(input_image);
if size(img, 3) == 3
    img = rgb2gray(img); % Convert to grayscale if the image is RGB
end
img = double(img); % Convert to double for processing

% Parameters
interp_method = 'bicubic';

% Measure Time for Construction
tic;
downsampled = blockproc(img, [2, 2], @(block) max(block.data(:))); % Max pooling
time_downsampling = toc;

% Measure Time for Reconstruction
tic;
upsampled = imresize(downsampled, 2, interp_method); % Upsample by 2
time_reconstruction = toc;

% Measure Memory Usage
vars = whos;
memory_usage = sum([vars.bytes]) / 1e6; % Total memory in MB

% Save Images
imwrite(uint8(img), 'max_pooling_original_imageT.png'); % Save original image
imwrite(uint8(downsampled), 'max_pooling_downsampled_imageT.png'); % Save downsampled image
imwrite(uint8(upsampled), 'max_pooling_reconstructed_imageT.png'); % Save reconstructed image

% Display Results
fprintf('Max Pooling Pyramid:\n');
fprintf('Time for Downsampling: %.4f seconds\n', time_downsampling);
fprintf('Time for Reconstruction: %.4f seconds\n', time_reconstruction);
fprintf('Memory Usage: %.2f MB\n', memory_usage);
