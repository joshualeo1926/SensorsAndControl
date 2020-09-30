classdef Laser
    properties
        
    end
    
    methods
        function self = Laser(self)
            
        end
        
        %% Function check_collision will identify if a point in laser_data lies within the cutoff range
        % laser_data = laser data obtained via Fetch class
        % cutoff = distance in "m" that the bot should return as dangerous
        function IsCollision = check_collision(self, laser_data, cutoff)
            counter = size(laser_data.Ranges);
            counter = counter(1);
            
            IsCollision = 0;
            
            for i = 1:counter
                if (laser_data.Ranges(i) < cutoff)
                    %% Archived - Function can return debug data
                    %breachAngle = (data1.AngleMin + (i * data1.AngleIncrement));
                    %disp(['Breached at ', num2str(breachAngle)])
                    
                    %% Current - Function will return a collision flag
                    IsCollision = 1;
                end
            end
        end
    end
end

