function [] = draw(x0,y0,a,b,theta)
t = 0 : 0.01 : 2 * pi;
idx = t>pi;
    xt = a * cos(t(idx));
    yt = b * sin(t(idx));
    xe = xt * cos(theta) + yt * sin(theta);
    ye = yt * cos(theta) - xt * sin(theta);
    plot((x0 + xe), (y0 + ye) ,'--','color', 'g','linewidth',1);
    
    xt = a * cos(t(~idx));
    yt = b * sin(t(~idx));
    xe = xt * cos(theta) + yt * sin(theta);
    ye = yt * cos(theta) - xt * sin(theta);
    plot((x0 + xe), (y0 + ye) ,'color', 'g','linewidth',1);
    drawnow
end

