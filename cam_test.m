close all;
clear all;
clc;

fetch_con = Fetch();
target_image = imread("Marker_5101520.png");
gry_target_image = imcomplement(uint8(255 * ceil(mat2gray(target_image))));
target_features = detectSURFFeatures(gry_target_image);
[target_extracted_features, target_points] = extractFeatures(gry_target_image, target_features);

for i=0:1
    rgb_data = fetch_con.get_rgb_image();
    img = readImage(rgb_data);
    gry_img = rgb2gray(img);
    img_features = detectSURFFeatures(gry_img);
    [img_extracted_features, img_points] = extractFeatures(gry_img, img_features);
    
    matched_features = matchFeatures(target_extracted_features, img_extracted_features,'MaxRatio', 0.3, 'Unique', true );
    
    matched_target_point = target_points(matched_features(:, 1), :);
    matched_img_point = img_points(matched_features(:, 2), :);
    
    if matched_img_point.Count > 20
       [tf, ~, ~, status] = estimateGeometricTransform(matched_target_point, matched_img_point, 'affine');
       
       bbox = [1, 1; ...
           size(gry_target_image, 2), 1;...
           size(gry_target_image, 2), size(gry_target_image, 1);...
           1, size(gry_target_image, 1);...
           1, 1];
       
       transformed_bbox = transformPointsForward(tf, bbox);
       
       top_left_x = transformed_bbox(1, 1);
       top_right_x = transformed_bbox(2, 1);
       bot_left_x = transformed_bbox(3, 1);
       bot_right_x = transformed_bbox(4, 1);
       
       top_left_y = transformed_bbox(1, 2);
       top_right_y = transformed_bbox(2, 2);
       bot_left_y = transformed_bbox(3, 2);
       bot_right_y = transformed_bbox(4, 2);
       
       top_mid_x = ((top_right_x - top_left_x)/2) + top_left_x;
       bot_mid_x = ((bot_right_x - bot_left_x)/2) + bot_left_x;
       
       right_mid_y = ((top_right_y - bot_right_y)/2) + bot_right_y;
       left_mid_y = ((top_left_y - bot_left_y)/2) + bot_left_y;
       
       mid_x = abs((top_mid_x + bot_mid_x)/2)
       mid_y = abs((right_mid_y + left_mid_y)/2)
       
       mid_x = abs(((transformed_bbox(2, 1) + transformed_bbox(1, 1))/4) + ((transformed_bbox(4, 1) + transformed_bbox(3, 1))/4))
       mid_y = abs(((transformed_bbox(2, 2) + transformed_bbox(4, 2))/4)  + ((transformed_bbox(1, 2) + transformed_bbox(3, 2))/4))
       
       x_error = mid_x - size(gry_img, 2)/2;
       
       marked = insertMarker(img,[mid_x mid_y] , 'color', 'red', 'size', 10);
       line(transformed_bbox(:, 1), transformed_bbox(:, 2), 'Color', 'y');
       title('target_found');
       imshow(marked);

       figure(2);
       showMatchedFeatures(gry_target_image, img, matched_target_point, matched_img_point, 'montage');
       drawnow;
    end
end
