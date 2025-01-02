# Reconstruction Quality Analysis of Gaussian, Max Pooling, and Max-Averaging Pyramids

## Abstract
This project investigates the reconstruction quality of three image pyramid methods—**Gaussian Pyramid**, **Max Pooling Pyramid**, and **Max-Averaging Pyramid**—using their 1-level (base layer) implementations. The analysis evaluates reconstruction quality using the **Structural Similarity Index (SSIM)**, computational efficiency (execution time and memory usage), and the impact of key parameters such as interpolation methods and downsampling factors.

## Objectives
1. **Parameter Optimization**: Determine optimal parameters (e.g., bandwidth \( \sigma \) for Gaussian Pyramid).
2. **Interpolation Analysis**: Evaluate reconstruction quality with **nearest-neighbor**, **bilinear**, and **bicubic** interpolation methods.
3. **Downsampling Factor Analysis**: Examine the effects of factors \(2, 4, \) and \(8\) on reconstruction quality.
4. **Computational Efficiency**: Compare execution time and memory usage of the pyramid methods.
5. **Comprehensive Comparison**: Highlight trade-offs, strengths, and suitability of each method.

## Key Findings
- **Gaussian Pyramid**:
  - Most computationally efficient, ideal for resource-constrained applications.
  - Bicubic interpolation yielded the best reconstruction quality (highest SSIM).
- **Max Pooling Pyramid**:
  - Balanced edge retention and computational efficiency.
  - Effective for feature extraction but suffers at higher downsampling factors.
- **Max-Averaging Pyramid**:
  - Best reconstruction quality across all analyses (highest SSIM overall).
  - Computationally intensive, suitable for applications prioritizing high-quality reconstruction.

## Project Structure
- `Image Pyramids report.pdf`: Detailed report of the analysis, findings, and methodology.
- `code`: MATLAB scripts

## Methodology
1. **Gaussian Pyramid**:
   - Downsampling with Gaussian smoothing.
   - Reconstruction with bicubic interpolation.
2. **Max Pooling Pyramid**:
   - Downsampling by retaining maximum pixel values.
   - Reconstruction with bicubic interpolation.
3. **Max-Averaging Pyramid**:
   - Combines max pooling and average pooling with adjustable weights.
   - Reconstruction with bicubic interpolation.

## Results
- **Optimal Bandwidth (σ)**: Gaussian Pyramid performed best with \( \sigma = 1.5 \).
- **Interpolation**: Bicubic interpolation consistently provided the best SSIM across all methods.
- **Downsampling Factor**: A factor of 2 balanced data reduction and reconstruction quality for all methods.
- **Computational Efficiency**:
  - Gaussian Pyramid: Fastest and most memory-efficient.
  - Max-Averaging Pyramid: Highest computational cost but best quality.

## References
1. Z. Wang et al., "Image Quality Assessment: From Error Visibility to Structural Similarity," *IEEE Transactions on Image Processing*, 2004.
2. P. Burt and E. Adelson, "The Laplacian Pyramid as a Compact Image Code," *IEEE Transactions on Communications*, 1983.
3. M. D. Zeiler and R. Fergus, "Stochastic Pooling for Regularization of Deep Convolutional Neural Networks," *ICLR Proceedings*, 2013.
4. A. Hore and D. Ziou, "Image Quality Metrics: PSNR vs. SSIM," *International Conference on Pattern Recognition*, 2010.

## Applications
- Image Compression
- Super-Resolution
- Multi-Scale Image Analysis
- Medical Imaging and Restoration
