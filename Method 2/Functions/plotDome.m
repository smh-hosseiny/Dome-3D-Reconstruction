function [] = plotDome(lb, ub, prh, dh, Img, rep)
    nt = rep;
    rimgt = repmat(Img(:,:,1),1,2*nt);
    gimgt = repmat(Img(:,:,2),1,2*nt);
    bimgt = repmat(Img(:,:,3),1,2*nt);
    imgtt = [];
    imgtt(:,:,1) = uint8(rimgt);
    imgtt(:,:,2) = uint8(gimgt);
    imgtt(:,:,3) = uint8(bimgt);
    imgtt = uint8(imgtt);
    figure;
    h = lb*dh:dh/10:ub*dh;
    rh = polyval(prh,h);
    [x,y,z] = cylinder(rh,180);
    z = repmat(h',1,181);
    surf(100*x,100*y,100*z,imgtt,'FaceColor','texturemap','Edgecolor','none');
    axis equal
    camproj('perspective');
    title('3D model');
    
end