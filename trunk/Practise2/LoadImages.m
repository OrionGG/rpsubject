function [X,LABELS] = LoadImages
%LOADIMAGES Summary of this function goes here
%   Detailed explanation goes here
dimResize = 25;

dirs = dir(['./imagenes_practica2/']);
isub = [dirs(:).isdir]; %# returns logical vector
nameFolds = {dirs(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

X = [];
LABELS = [];

for iFold = 1:length( nameFolds)
    folder = sprintf('./imagenes_practica2/%s/', char(nameFolds(iFold)));
    
    images = dir([folder '*.*']);    
    images_names = {images.name};
    images_names(ismember(images_names,{'.','..'})) = [];
    
    %reading each image
    for img = 1:length(images_names)
        imagefile = sprintf('%s%s', char(folder),images_names{img});

        [im,map] = imread (imagefile);
        if (~isempty(map))            
            im = ind2rgb(im,map);   
        end;        
        %resize images for haveing less data
        im = imresize(im, [dimResize, dimResize]);
        im = rgb2gray(im);
        im = double(im);
        X = [X; im(:)'];
        LABELS = [LABELS; iFold];
    end;
end;

end

