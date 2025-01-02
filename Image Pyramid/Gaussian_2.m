% Load an image
img = imread("C:/Users/DHARMESH M/Documents/MATLAB/Pyramid Projects/UCSB.jpeg"); % Replace with your image path
if size(img, 3) == 3
    gray_img = rgb2gray(img); % Convert to grayscale if image is RGB
else
    gray_img = img;
end

% Initialize variables
original_img = gray_img; % Save the original image
current_img = gray_img;  % Current level's image for processing
levels = 3;              % Number of pyramid levels
downsampled_images = cell(1, levels); % Store downsampled images
ssim_values = zeros(1, levels); % Store SSIM values

% Downsampling Process
for level = 1:levels
    % Apply Gaussian Blurring
    blurred_img = imgaussfilt(current_img, 1.6); % Gaussian blur with sigma=1.6
    
    % Downsample by a factor of 2
    downsampled_img = imresize(blurred_img, 0.5, 'bicubic');
    downsampled_images{level} = downsampled_img;
    
    % Update current image for next level
    current_img = downsampled_img;
end

% Reconstruction Process (Direct Upsampling)
for level = 1:levels
    % Upsample directly to original size
    reconstructed_img = imresize(downsampled_images{level}, size(original_img), 'bicubic');
    
    % Calculate SSIM between original image and reconstructed image
    ssim_values(level) = ssim(reconstructed_img, original_img);
    
    % Visualize the reconstructed image
    figure;
    imshow(reconstructed_img);
    title(['Reconstructed Image from Level ', num2str(level)]);
end

% Display SSIM values
disp('SSIM values for independent reconstruction:');
for level = 1:levels
    fprintf('Level %d (Reconstructed): SSIM = %.4f\n', level, ssim_values(level));
end
