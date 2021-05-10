%Коэффициент, учитывающий диаграмму направленности космического объекта
function VqObject = objectPattern(VObject, receiverLocation, objectLocation, objectVelocity)
    %вектор объект - приёмник
    objectReceiver = [receiverLocation(1) - objectLocation(1), receiverLocation(2) - objectLocation(2), receiverLocation(3) - objectLocation(3)];
    %скалярное произведение вектора объект-приёмник и вектора скорости
    %спутника
    scalarORV = (objectReceiver(1) * objectVelocity(1) + objectReceiver(2) * objectVelocity(2) + objectReceiver(3) * objectVelocity(3));
    %угол между вектором объект-приёмник и вектором скорости спутника
    phi = rad2deg(acos((scalarORV) / (sqrt(objectReceiver(1)^2 + objectReceiver(2)^2 + objectReceiver(3)^2) * sqrt(objectVelocity(1)^2 + objectVelocity(2)^2 + objectVelocity(3)^2))));
    %вектор вертикали
    objectHeight =  - objectLocation;
    %скалярное произведение вектора вертикали и вектора объект-приёмник 
    scalarOROH = (objectReceiver(1) * objectHeight(1) + objectReceiver(2) * objectHeight(2) + objectReceiver(3) * objectHeight(3));
    %угол между вектором вертикали и вектором объект-приёмник
    theta = rad2deg(acos((scalarOROH) / (sqrt(objectReceiver(1)^2 + objectReceiver(2)^2 + objectReceiver(3)^2) * sqrt(objectHeight(1)^2 + objectHeight(2)^2 + objectHeight(3)^2))));
    %отклонение максимума диаграммы направленности от вектора скорости
    phiMax = 90;
    %отклонение максимума диаграммы направленности от вектора вертикали
    thetaMax = 35;
    %отклонение вектора объект-приёмник от максимума диаграммы направленности по двум направлениям
    deltaPhi = round((phi - phiMax) * 10) / 10;
    deltaTheta = round((theta - thetaMax) * 10) / 10;
    %находим нужные значения в данной матрице ДН (+450, т.к в матрице углы от -45 до +45)
    VqObject = VObject(deltaPhi * 10 + 450, deltaTheta * 10 + 450);
end