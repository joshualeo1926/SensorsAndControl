classdef Fetch < handle
    properties
       img_sub 
    end
    
    methods
        function self = Fetch(self)
            rosshutdown;
            rosinit;
            self.img_sub = rossubscriber('/head_camera/rgb/image_raw', 'sensor_msgs/Image');           
        end
        
        function rgb_data = get_rgb_image(self)
            rgb_data = receive(self.img_sub);
        end
    end
end