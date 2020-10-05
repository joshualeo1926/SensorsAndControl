classdef Laser
    properties
        cutoff
    end
    
    methods
        function self = Laser(cutoff)
            self.cutoff = cutoff;
        end
        
        %% Function check_collision will identify if a point in laser_data lies within the cutoff range
        % laser_data = laser data obtained via Fetch class
        % cutoff = distance in "m" that the bot should return as dangerous
        function IsCollision = check_collision(self, laser_data)
            counter = size(laser_data.Ranges, 1);
            
            IsCollision = 0;
            
            for i = 1:counter
                if (laser_data.Ranges(i) < self.cutoff)
                    %% Archived - Function can return debug data
                    %breachAngle = (data1.AngleMin + (i * data1.AngleIncrement));
                    %disp(['Breached at ', num2str(breachAngle)])
                    
                    %% Current - Function will return a collision flag
                    IsCollision = 1;
                    return
                end
            end
        end
        
        function ReturnDistance = return_distance(self, laser_data, angle)
            if angle < laser_data.AngleMin || angle > laser_data.AngleMax
                % Return -1 if the angle is invalid
                ReturnDistance = -1;
            else
                counter = size(laser_data.Ranges);
                counter = counter(1);
                
                for i = 1:counter
                    currentAngle = laser_data.AngleMin + (i * laser_data.AngleIncrement);
                    
                    if currentAngle == angle
                        ReturnDistance = laser_data.Ranges(i);
                    elseif currentAngle > angle
                        ReturnDistance = laser_data.Ranges(i-1);
                        break;
                    end
                end
            end
        end
    end
end

