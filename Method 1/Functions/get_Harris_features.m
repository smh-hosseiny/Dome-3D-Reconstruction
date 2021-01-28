function [Ix,Iy,FeaturesMatrix] = get_Harris_features(Image,x,y)
    I = rgb2gray(Image);
    corners = detectHarrisFeatures(I);
    [features, valid_corners] = extractFeatures(I, corners);
    L = valid_corners.Location;
    Ix = L(:,1); Iy = L(:,2);
    FeaturesMatrix = double(features.Features);
    [Ix,Iy,FeaturesMatrix] = get_in_range_points(Ix,Iy,FeaturesMatrix,x,y);
    

%     imshow(Image);
%     hold on; plot(Ix,Iy, 'g.');
%     plot(x,y, 'linewidth',1.5);
    

end

