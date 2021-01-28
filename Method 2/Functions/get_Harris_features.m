function [Ix,Iy,FeaturesMatrix] = get_Harris_features(Image,x,y,Img)
    I = rgb2gray(Image);
    corners = detectHarrisFeatures(I);
    [features, valid_corners] = extractFeatures(I, corners);
%     valid_corners = valid_corners.selectStrongest(800);
    L = valid_corners.Location;
    Ix = L(:,1); Iy = L(:,2);
    FeaturesMatrix = double(features.Features);
    % FeaturesMatrix = normalize(FeaturesMatrix,1);
    [Ix,Iy,FeaturesMatrix] = get_in_range_points(Ix,Iy,FeaturesMatrix,x,y);
    
    if nargin == 3
        img = Image;
    else
        img = Img;
    end
%     imshow(img);
%     hold on; plot(Ix,Iy, 'g.');
%     plot(x,y, 'linewidth',1.5);
%     title('feature points');
    

end

