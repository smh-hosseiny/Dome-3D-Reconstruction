function GUI
clc; clear; close all;
image = imread('images.jpg');
f = figure('Visible','off','Position',[360,500,400,300]);
ha = axes('unit', 'normalized', 'position', [0 0 1 1]);
imagesc(image);

global current_folder;
current_folder = pwd;

% Construct the components.
h1 = uicontrol('Style','pushbutton','String','Path to image',...
           'Position',[0,220,70,25], 'Callback',{@Pathbutton_Callback});
h2  = uicontrol('Style','text','String','Choose Method',...
           'Position',[315,170,100,15]);
       
h3 = uicontrol('Style','popupmenu',...
           'String',{'---','Method 1','Method 2'},...
           'Position',[300,140,100,25],'Callback',{@popup_menu_Callback});
       
h4 = uicontrol('Style','pushbutton','String','Run',...
           'Position',[315,90,70,25],'Callback',{@Runbutton_Callback});
 


align([h1,h2,h3,h4],'Center','None');

f.Units = 'normalized';
h1.Units = 'normalized';
h2.Units = 'normalized';
h3.Units = 'normalized';
h4.Units = 'normalized';
f.Name = 'GUI';
movegui(f,'center')
f.Visible = 'on';
end

 function popup_menu_Callback(source,eventdata) 
 global current_folder;
 disp(current_folder);
      str = source.String;
      val = source.Value;
      switch str{val}
      case 'Method 1' 
         cd(current_folder);
         cd 'Method 2'
      case 'Method 2' 
         cd(current_folder);
         cd 'Method 1'
      end
 end

function Pathbutton_Callback(source,eventdata) 
global Image_of_dome;
[file,path] = uigetfile('*.png; *.jpg; *.jpeg',...
               'Select an image');
selectedfile = fullfile(path,file);
Image_of_dome = imread(selectedfile);
end

function Runbutton_Callback(source,eventdata)
    global Image_of_dome;
    global current_folder;
    run(Image_of_dome);
    cd(current_folder);
end
