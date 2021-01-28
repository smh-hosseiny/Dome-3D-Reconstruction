classdef Circle < handle
    properties
        radius
        center
        normal
        pnt3d
        pnt2d
        center2d
    end
    
    methods
        function obj = Circle(c,n,r)
            obj.radius = r;
            obj.center = c;
            obj.normal = n;
        end
        
        function obj = refine_normal(obj)
            [~, index] = max([obj.normal{1}(2), obj.normal{2}(2)]);
            obj.radius = obj.radius{index};
            obj.center = obj.center{index};
            obj.normal = obj.normal{index};
        end
        
        
        function obj = set_normal(obj, n)
            obj.normal = n;
        end
        
        
        function obj = find_3d_circle(obj, theta)
            if nargin == 1
               th = linspace(0,2*pi,500);
            else
                th = theta;
            end
            obj.pnt3d = obj.get_points_3d(th);
        end
        
        
        function points3d = get_points_3d(obj, theta)
            r=obj.radius; c=obj.center; n=obj.normal;
            P = null(n');
            points3d = bsxfun(@plus,c,r*P*[cos(theta); sin(theta)]);
        end
        
        
        function obj = project2d(obj, f)
            K = [f, 0, 0; 0, f, 0; 0, 0, 1];
            qcircle = K * obj.pnt3d;
            ProjPoints = qcircle(1 : 2, :) ./ qcircle(3, :);
            
            px = ProjPoints(1,:);  py=ProjPoints(2,:); 
            points = cat(2, [px; py]);
            cntr = K * obj.center;
            cntr = cntr(1:2)/cntr(3);
            obj.pnt2d = points;
            obj.center2d = cntr;
        end
        
        
        function plot3d(obj)
            plot3(obj.pnt3d(1,:), obj.pnt3d(2,:), obj.pnt3d(3,:),'color', 'b');            
        end


        function plot2d(obj, ysize)
            px = obj.pnt2d(1,:); py = obj.pnt2d(2,:);
            [~,idx1] = min(px);
            [~,idx2] = max(px);
            u_rng = (min(idx1,idx2): max(idx1,idx2));
            rng3 = (1:min(idx1,idx2));
            rng2 = (max(idx1,idx2):length(px));
            l_rng = cat(1, [rng2,rng3]);
            [~, minY] = max(py);
            if ismember(minY, u_rng)
                temp  = l_rng;
                l_rng = u_rng;
                u_rng = temp;
            end
            
            hold on;
            if nargin == 2
                plot(px,ysize - py,'color', 'r','linewidth',0.5);
            else           
                plot(px(l_rng), py(l_rng) ,'color', 'y','linewidth',1);
                plot(px(u_rng), py(u_rng), '--', 'color', 'y','linewidth',1);            
            end
        end
        
        
        function obj = refine_center(obj, ref_center, h)
            obj.center = ref_center + obj.normal*h;
            obj.find_3d_circle();
        end
        
        function theta = find_theta(obj)
            p = fit_ellipse_parameters(obj.pnt2d(1,:),obj.pnt2d(2,:));
            [theta,~] = ellipse_param(p);
        end
        
    end
end

