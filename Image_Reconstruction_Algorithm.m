%----------------------------------------------------------------------------------------------% 
%  Project       : Parallel-beam tomographic image reconstruction algorithm                    %
%  File          : Image_Reconstruction_Algorithm.m                                            %
%  Description   : Image reconstruction using different type of filters for Backprojection     %
%  Author        : Monahopoulos Konstantinos                                                   %
%----------------------------------------------------------------------------------------------%

clc;close all; clear all 

% Projection Degrees 1:360
theta=1:360;

%Initialize string Filter
filter_handler=char('None','Ram-Lak','Shepp-Logan','Cosine','Hamming','Hann');

%Read Image and normilize it [0,1]
InitImage=im2double(imread('test4.tif')); 

%Plot Initial Image
imshow(InitImage);
title('Original Image');

%Create Sinogram of original Image
Sinogram = radon(InitImage,theta);

%Plot the Sinogram of the original Image
figure,imagesc(Sinogram)
colormap(hot); colorbar 
title('Sinogram Of Original Image');

%Initialize coordinates for line of interest
XCoor=[13,49]; 
YCoor=[68,49];

% Plot values of line of interest for Original Image
ValOfInterest = improfile(InitImage,XCoor,YCoor);
figure,plot(ValOfInterest);
title('Original Image Line Of Interest');

for string_counter=1:size(filter_handler,1)

% Make Reconstruction Image with Filter
FilteredImage =iradon(Sinogram,theta,'linear',filter_handler(string_counter,1:end-sum(isspace(filter_handler(1,:)))),0.90);

if (strcmp(filter_handler(string_counter,1:end-sum(isspace(filter_handler(1,:)))),'None'))
    FilteredImage=FilteredImage/255;
end

%Plot Original Image and Reconstructed Image
figure;
subplot(2,2,1), imshow(InitImage);
title('Original');
subplot(2,2,2), imshow(FilteredImage);
title('Filtered backprojection');
suptitlestring= strcat('Image Comparison filter:',horzcat(' ',filter_handler(string_counter,:))   );
suptitle(suptitlestring);

% Compute values of line of interest for every filtered image
LineOfInterest = improfile(FilteredImage,XCoor,YCoor);

% Plot values of line of interest for every filtered image
subplot(2,2,[3,4]),plot(LineOfInterest);
suptitlestring= strcat('Line Of Interest filter:',horzcat(' ',filter_handler(string_counter,:))   );
title(suptitlestring);

% Compute Sinogram of filtered Image for every filter
FilteredSinogram = radon(FilteredImage,theta);

%Plot Sinogram of filtered Image for every filter
figure,imagesc(FilteredSinogram)
colormap(hot); colorbar 
suptitlestring= strcat('Sinogram filter:',horzcat(' ',filter_handler(string_counter,:))   );
suptitle(suptitlestring);

end
