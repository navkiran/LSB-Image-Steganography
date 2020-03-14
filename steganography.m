clc;
clear variables;
% Load the image and convert to grayscale if it is RGB
I=imread('input.png');
[rows, columns, numberOfColorChannels] = size(I);
if numberOfColorChannels > 1
    I = rgb2gray(I);
end
L=256;
imageWithHiddenData=I;

message=input('Please enter the message you want to hide: ','s');
% Each character occupies a byte, so total bits can be found by multiplying
% string length by 8
len=strlength(message)*8;
% error handling
if strlength(message) > (rows*columns)
    disp('Cover image size is not enough to encode full message!')
end
ascii_values=uint8(message);   
ascii2binary=dec2bin(ascii_values,8);

% Append all binary equivalents of ascii values into one string
binary_sequence='';  
for i=1:strlength(message)
    binary_sequence=append(binary_sequence,ascii2binary(i,:));
end

% To track how many bits of message have been hidden
bitCount=1;

for i=1:rows
    for j=1:columns
        
        if bitCount<=len
            %Obtain the LSB of the grey level of the pixel
            LSB=bitget(I(i,j),1);
            
            %Convert the bit from the message to numeric form
            bitInMessage=str2double(binary_sequence(bitCount));
            %Reset LSB
            imageWithHiddenData(i,j)= bitand(imageWithHiddenData(i,j),0b11111110);
            %Replace LSB with bitInMessage
            imageWithHiddenData(i,j) = imageWithHiddenData(i,j) + bitInMessage;
            
            bitCount=bitCount+1;
        end
    end
end

subplot(1,2,1);
imshow(I);
title('Input Image');

subplot(1,2,2);
imshow(imageWithHiddenData);
title('Image with Hidden Data');

imwrite(imageWithHiddenData,'output.png')

