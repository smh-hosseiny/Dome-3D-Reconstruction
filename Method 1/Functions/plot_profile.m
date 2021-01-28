function [same_pattern_scores] = plot_profile(circles,x,y,Ix,Iy,FeaturesMatrix,Image,plot_3d)

if nargin == 7
    p3d = false;
    imshow(Image);
else
    p3d = plot_3d;
end

axis equal; hold on;

same_pattern_scores = ones(size(circles));

for i= 1:length(circles) 
    if p3d == true
        circles(i).plot3d();
    else
        circles(i).plot2d();
        p = circles(i).pnt2d;
        px = double(p(1,:)); py = double(p(2,:));
        s = get_score(px,py,Ix,Iy,FeaturesMatrix);
        same_pattern_scores(i) = s;
    end
end
    if p3d == true
        grid on;
        camproj('perspective');
        set (gca,'YDir','reverse');
    else
        plot(x,y,'linewidth', 1.5,'color','r');
    end
    

end

