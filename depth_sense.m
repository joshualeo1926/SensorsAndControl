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
            distance = depth_image(y_pixel, x_pixel);
            min_dist = min(depth_image(:));
        end
        
        
    end
end