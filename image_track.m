classdef image_track < handle
    properties
       target_image = imread("Marker_5101520.png");
       gry_target_image = imcomplement(uint8(255 * ceil(mat2gray(target_image))));
       target_extracted_features;
       target_points;

    end
    
    methods
        function self = image_track()
            target_features = detectSURFFeatures(gry_target_image);
            [self.target_extracted_features, self.target_points] = extractFeatures(gry_target_image, target_features);
        end
        
        function [target_found, x_err, x_pixel, y_pixel] = get_error(input_img)
            input_gry_img = rgb2gray(input_img);
            input_features = detectSURFFeatures(input_gry_img);
            [input_extracted_features, input_points] = extractFeatures(input_gry_img, input_features);
            
            matched_features = matchFeatures(self.target_extracted_features, input_extracted_features,'MaxRatio', 0.3, 'Unique', true );
            
            if matched_img_point.Count > 20
                target_matched_points = self.target_points(matched_features(:, 1), :);
                input_matched_features = input_points(matched_features(:, 1), :);
                
                [tf, ~, ~, ~] = estimateGeometricTransform(target_matched_points, input_matched_features, 'affine');
       
                bbox = [1, 1; ...
                	size(self.gry_target_image, 2), 1;...
                    size(self.gry_target_image, 2), size(self.gry_target_image, 1);...
                    1, size(self.gry_target_image, 1);...
                    1, 1];

                transformed_bbox = transformPointsForward(tf, bbox);

                x_pixel = abs(((transformed_bbox(2, 1) + transformed_bbox(1, 1))/4) + ((transformed_bbox(4, 1) + transformed_bbox(3, 1))/4));
                y_pixel = abs(((transformed_bbox(2, 2) + transformed_bbox(4, 2))/4)  + ((transformed_bbox(1, 2) + transformed_bbox(3, 2))/4));

                x_err = mid_x - size(gry_img, 2)/2;
                target_found = true;
            else
                x_pixel = 9999;
                y_pixel = 9999;
                x_err = 9999;
                target_found = false;
            end

        end
    end
end