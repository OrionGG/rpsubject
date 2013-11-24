function [img_grad] = gradient_sobel (img_gray)


    h = fspecial('sobel');
    img_sobelx = imfilter(img_gray,h','replicate');
    img_sobely = imfilter(img_gray,h,'replicate');

    img_grad =  zeros(size(img_sobelx,1),size(img_sobely,2));
 
    for i=1: size(img_sobelx,1)
        for j=1: size(img_sobely,2)
           img_grad(i,j) = (180*atan2(img_sobelx(i,j),...
           img_sobely(i,j)))/pi;
           if img_grad(i,j) < 0
             img_grad(i,j)= 360 + img_grad(i,j);
           end
        end
    end

end