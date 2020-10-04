classdef depth_sense < handle
    properties
        debug
    end
    methods
        function self = depth_sense(debug)
            self.debug = debug;
        end
        function [distance] = get_distance(self, depth_data, x_pixel, y_pixel)
            depth_image = readImage(depth_data);
            depth_image(x_pixel, y_pixel)
            distance = max(min(depth_image(x_pixel, y_pixel)/8, -1), 1);
        end
    end
end