%Коэффициент, учитывающий диаграмму направленности приёмника
function VqReceiver = receiverWeakening(VReceiver, receiverGeocen, objectGeocen, objectVelocity, timesDistance, spheroid)
    i = 1;
    VqReceiver = zeros(1, length(timesDistance)); %массив значений коэффициента
    radiusEarth = 6371 * 10^3;
    gammaFixed = 0; %направление на спутник по возвышению
    azFixed = 0; %направление на спутник по азимуту
    count = 0;
    for time = timesDistance
        %вектор объект - приёмник
        objectReceiver = [receiverGeocen(1) - objectVelocity(1) * time - objectGeocen(1), receiverGeocen(2) - objectVelocity(2) * time - objectGeocen(2), receiverGeocen(3) - objectVelocity(3) * time - objectGeocen(3)];
        %вектор вертикали
        objectHeight =  - objectGeocen - objectVelocity * time;
        %скалярное произведение вектора вертикали и вектора объект-приёмник 
        scalarOROH = (objectReceiver(1) * objectHeight(1) + objectReceiver(2) * objectHeight(2) + objectReceiver(3) * objectHeight(3));
        %угол между вектором вертикали и вектором объект-приёмник
        beta = acos((scalarOROH) / (sqrt(objectReceiver(1)^2 + objectReceiver(2)^2 + objectReceiver(3)^2) * sqrt(objectHeight(1)^2 + objectHeight(2)^2 + objectHeight(3)^2)));
        %угол на спутник по возвышению
        gamma = rad2deg(acos(sin(beta) * abs(sqrt(objectHeight(1) ^ 2 + objectHeight(2) ^ 2 + objectHeight(3) ^ 2)) / radiusEarth));
        %координаты спутника с учётом пройденного расстояния
        objectGeocenUpd = objectGeocen - objectVelocity * time;
        %переводим координаты в геодезическую систему координат
        [objectLat, objectLon, ~] = ecef2geodetic(spheroid, objectGeocenUpd(1), objectGeocenUpd(2), objectGeocenUpd(3));
        [receiverLat, receiverLon, ~] = ecef2geodetic(spheroid, receiverGeocen(1), receiverGeocen(2), receiverGeocen(3));
        %находим азимут
        [~, az] = distance(receiverLat, receiverLon, objectLat, objectLon, spheroid);
        %подправляем антенну каждые 100 отсчётов
        if mod(count, 100) == 0
            gammaFixed = gamma;
            azFixed = az;
            count = 0;
        end
        %ищем соответствующие значения в матрице диаграммы направленности
        VqReceiver(i) = VReceiver(round(gammaFixed - gamma + (size(VReceiver, 1) + 1) / 2), round(azFixed - az + (size(VReceiver, 1) + 1) / 2));
        i = i + 1;
        count = count + 1;
    end
end