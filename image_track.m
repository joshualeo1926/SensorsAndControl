classdef image_track < handle
    properties
       target_image;
       gry_target_image;
       target_extracted_features;
       target_points;
       debug;

    end
    
    methods
        function self = image_track(debug)
            self.debug = debug;
            self.target_image = imread("Marker_5101520.png");
            self.gry_target_image = imcomplement(uint8(255 * ceil(mat2gray(self.target_image))));
            target_features = detectSURFFeatures(self.gry_target_image);
            [self.target_extracted_features, self.target_points] = extractFeatures(self.gry_target_image, target_features);
        end
        
        function [target_found, x_err, x_pixel, y_pixel] = get_error(self, input_img)
            input_gry_img = rgb2gray(input_img);
            input_features = detectSURFFeatures(input_gry_img);
            [input_extracted_features, input_points] = extractFeatures(input_gry_img, input_features);
            
            matched_features = matchFeatures(self.target_extracted_features, input_extracted_features,'MaxRatio', 0.3, 'Unique', true );
            target_matched_points = self.target_points(matched_features(:, 1), :);
            input_matched_features = input_points(matched_features(:, 2), :);
            
            if input_matched_features.Count > 20
                [tf, ~, ~, ~] = estimateGeometricTransform(target_matched_points, input_matched_features, 'affine');
       
                bbox = [1, 1; ...
                	size(self.gry_target_image, 2), 1;...
                    size(self.gry_target_image, 2), size(self.gry_target_image, 1);...
                    1, size(self.gry_target_image, 1);...
                    1, 1];

                transformed_bbox = transformPointsForward(tf, bbox);

                x_pixel = abs(((transformed_bbox(2, 1) + transformed_bbox(1, 1))/4) + ((transformed_bbox(4, 1) + transformed_bbox(3, 1))/4));
                y_pixel = abs(((transformed_bbox(2, 2) + transformed_bbox(4, 2))/4)  + ((transformed_bbox(1, 2) + transformed_bbox(3, 2))/4));

                x_err = x_pixel - size(input_img, 2)/2;
                target_found = true;
                
                if self.debug
                    figure(1);
                    marked = insertMarker(input_img, [x_pixel y_pixel] , 'color', 'red', 'size', 10);
                    line(transformed_bbox(:, 1), transformed_bbox(:, 2), 'Color', 'y');
                    title('target_found');
                    imshow(marked);

                    figure(2);
                    showMatchedFeatures(self.gry_target_image, input_gry_img, target_matched_points, input_matched_features, 'montage');
                    drawnow;
                end
            else
                x_pixel = 9999;
                y_pixel = 9999;
                x_err = 9999;
                target_found = false;
            end

        end
    end
end