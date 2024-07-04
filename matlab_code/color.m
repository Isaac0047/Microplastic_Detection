function [RGB_color, HSV_color] = color(mask_label, image_seg)

[number, m, n] = size(mask_label);

image_seg_final = zeros(number,m,n,3);
RGB_color = zeros(number,3);

for jj = 1:number
    
    image_seg_final(jj,:,:,:) = squeeze(image_seg(jj,:,:,:));
    RGB_color(jj,1) = sum(sum(image_seg_final(jj,:,:,1))) / sum(sum(mask_label(jj,:,:)));
    RGB_color(jj,2) = sum(sum(image_seg_final(jj,:,:,2))) / sum(sum(mask_label(jj,:,:)));
    RGB_color(jj,3) = sum(sum(image_seg_final(jj,:,:,3))) / sum(sum(mask_label(jj,:,:)));

    %figure()
    %imshow(uint8(squeeze(image_seg(jj,:,:,:))))

end


%% RGB code to HSV code Conversion    
HSV_color = rgb2hsv(RGB_color/255);

HSV_color(:,1) = HSV_color(:,1) * 360;
HSV_color(:,2) = HSV_color(:,2) * 100;
HSV_color(:,3) = HSV_color(:,3) * 100;