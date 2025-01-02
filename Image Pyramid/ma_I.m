% Max Pooling Pyramid - Save Bicubic Interpolation Output

% Read and convert to grayscale
input_image = 'UCSB.jpeg'; % Specify your image file
img = imread(input_image);
if size(img, 3) == 3
    img = rgb2gray(img); % Convert to grayscale if the image is RGB
end
img = double(img); % Convert to double for processing

% Construct (Downsampling using Max Pooling)
downsampled = blockproc(img, [2, 2], @(block) max(block.data(:))); % Max pooling

% Bicubic Interpolation for Reconstruction
upsampled = imresize(downsampled, 2, 'bicubic'); % Upsample with bicubic interpolation

% Resize to match original size using bicubic interpolation
reconstructed_resized = imresize(upsampled, size(img), 'bicubic'); % Ensure size match

% Save Images
imwrite(uint8(img), 'original_image_max_pooling_bicubic.png'); % Save the original image
imwrite(uint8(downsampled), 'downsampled_image_max_pooling_bicubic.png'); % Save the downsampled image
imwrite(uint8(reconstructed_resized), 'reconstructed_image_max_pooling_bicubic.png'); % Save the reconstructed image

% Display SSIM Value
ssim_value = ssim(uint8(reconstructed_resized), uint8(img)); % Compute SSIM
disp(['SSIM for Max Pooling Pyramid with bicubic interpolation: ', num2str(ssim_value)]);
