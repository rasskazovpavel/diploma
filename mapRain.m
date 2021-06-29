function intensivity = mapRain(image)
    RGB = impixel(image, 512, 512);
    intensivity = 0;
    if RGB(3) >= 190 && RGB(3) <= 210
        intensivity = 2;
    end
    if RGB(3) >= 160 && RGB(3) <= 190
       intensivity = 5; 
    end
    if RGB(3) < 160
        intensivity = 10;
end