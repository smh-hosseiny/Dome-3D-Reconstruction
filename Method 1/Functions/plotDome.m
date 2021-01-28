
function [] = plotDome(prh, h, Img, rep)
    nt = rep;
    rimgt = repmat(Img(:,:,1),1,2*nt);
    gimgt = repmat(Img(:,:,2),1,2*nt);
    bimgt = repmat(Img(:,:,3),1,2*nt);
    imgtt = [];
    imgtt(:,:,1) = uint8(rimgt);
    imgtt(:,:,2) = uint8(gimgt);
    imgtt(:,:,3) = uint8(bimgt);
    imgtt = uint8(imgtt);

    figure
    rh = polyval(prh,h);
    [x,y,z] = cylinder(rh,180);
    z = repmat(h',1,181);
    surf(10*x,10*y,10*z,imgtt,'FaceColor','texturemap','Edgecolor','none');
    axis equal
    set (gca,'ZDir','reverse');
    camproj('perspective');
end