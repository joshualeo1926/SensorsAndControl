classdef depth_sense < handle
    properties
        debug
    end
    methods
        function self = depth_sense(debug)
            self.debug = debug;
        end
        function [distance, min_dist] = get_distance(self, depth_data, x_pixel, y_pixel)
            depth_image = readImage(depth_data);

            if x_pixel > size(depth_image, 2)
                x_pixel = size(depth_image, 2);
            elseif x_pixel < 1
                x_pixel = 1;
            end
            if y_pixel > size(depth_image, 1)
                y_pixel = size(depth_image, 1);
            elseif y_pixel < 1
                y_pixel = 1;
            end
                
            min_dist = min(depth_image(:));
            if y_pixel > size(depth_image, 2)
               distance = 9999;
               return
            end
            distance = depth_image(y_pixel, x_pixel);
            if self.debug
                figure(3);
                markedd = insertMarker(depth_image, [x_pixel y_pixel] , 'color', 'red', 'size', 10);
                title("target found")
                imshow(markedd);
            end
        end
        
        
    end
end