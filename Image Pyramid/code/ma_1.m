% Max Pooling Pyramid - 1 Level Construction and Reconstruction

% Read and convert to grayscale
input_image = 'UCSB.jpeg'; % Specify your image file
img = imread(input_image);
if size(img, 3) == 3
    img = rgb2gray(img); % Convert to grayscale if the image is RGB
end
img = double(img); % Convert to double for processing

% Step 1: Construct (Downsampling using Max Pooling)
[rows, cols] = size(img);
downsampled = blockproc(img, [2, 2], @(block) max(block.data(:))); % Apply max pooling

% Step 2: Reconstruct (Upsampling)
upsampled = repelem(downsampled, 2, 2); % Upsample by repeating each pixel value

% Step 3: Resize Reconstructed Image to Match Original
reconstructed_resized = imresize(upsampled, size(img), 'bicubic'); % Resize to match original size

% Step 4: Save Images
imwrite(uint8(img), 'original_image_max_pooling.png'); % Save the original image
imwrite(uint8(downsampled), 'downsampled_image_max_pooling.png'); % Save the downsampled image
imwrite(uint8(reconstructed_resized), 'reconstructed_image_max_pooling.png'); % Save the reconstructed image

% Display SSIM Value
[ssim_value, ~] = ssim(uint8(reconstructed_resized), uint8(img)); % Compute SSIM
disp(['SSIM between Original and Reconstructed Image: ', num2str(ssim_value)]);
