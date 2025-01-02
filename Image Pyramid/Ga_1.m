% Gaussian Filtering - FFT, Radial Frequency Analysis, and Visual Comparison

% Read and convert to grayscale
input_image = 'UCSB.jpeg'; % Replace with your image file
img = imread(input_image);
if size(img, 3) == 3
    img = rgb2gray(img); % Convert to grayscale if the image is RGB
end
img = double(img); % Convert to double for processing

% Parameters
sigma_values = [0.5, 1.0, 1.5, 2.0]; % Array of sigma values for Gaussian filtering

% Initialize figure for displaying results
figure('Name', 'Visual Analysis of Filtered Images');
for i = 1:length(sigma_values)
    sigma = sigma_values(i);

    % Apply Gaussian filtering
    smoothed = imgaussfilt(img, sigma);

    % Visual Analysis - Display Filtered Images
    subplot(2, length(sigma_values), i);
    imshow(uint8(smoothed));
    title(['Filtered (\sigma = ', num2str(sigma), ')']);

    % Compute FFT
    fft_filtered = abs(fftshift(fft2(smoothed)));
    fft_original = abs(fftshift(fft2(img)));

    % Radial Frequency Analysis
    [rows, cols] = size(img);
    center_x = ceil(rows/2);
    center_y = ceil(cols/2);
    [X, Y] = meshgrid(1:cols, 1:rows);
    radius = sqrt((X - center_x).^2 + (Y - center_y).^2);

    radial_energy = accumarray(round(radius(:)) + 1, fft_filtered(:)) ./ accumarray(round(radius(:)) + 1, 1);
    radial_frequency = 0:max(radius(:));

    % Plot Radial Frequency
    subplot(2, length(sigma_values), i + length(sigma_values));
    plot(radial_frequency, radial_energy, 'LineWidth', 1.5);
    title(['Radial Spectrum (\sigma = ', num2str(sigma), ')']);
    xlabel('Frequency Radius');
    ylabel('Energy');
end

% FFT Spectrum Visualization
figure('Name', 'FFT Spectrum Analysis');
for i = 1:length(sigma_values)
    sigma = sigma_values(i);

    % Apply Gaussian filtering
    smoothed = imgaussfilt(img, sigma);
    fft_filtered = abs(fftshift(fft2(smoothed)));

    % Display FFT Spectrum
    subplot(1, length(sigma_values), i);
    imshow(log(fft_filtered + 1), []);
    title(['Filtered Spectrum (\sigma = ', num2str(sigma), ')']);
end
