function waterContent = mapCloud(image)
    RGB = impixel(image, 512, 512);
    waterContent = 0;
    if sum(RGB) > 500
       waterContent = 1; 
    end
    if sum(RGB) > 550
       waterContent = 1.5;
    end
    if sum(RGB) > 600
        waterContent = 2;
    end
end