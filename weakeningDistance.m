%Коэффициент ослабления из-за дальности
function wD = weakeningDistance(receiverLocation, objectLocation)
    distance = sqrt(sum((receiverLocation - objectLocation) .^ 2));
    wD = 1 / (4 * pi * distance ^ 2);
end