%Функция, считающая расстояние между объектом и приёмником в различные моменты времени
function distanceCoefficients = distances(timesTau, receiverGeocen, objectGeocen, objectVelocity)
    distanceCoefficients = zeros(1, length(timesTau)); %задаём массив значений коэффициента
    count = 1;
    for time = timesTau
        distanceCoefficients(count) = sqrt(sum((receiverGeocen - objectGeocen - objectVelocity * time) .^ 2)); %считаем значение коэффициента
        count = count + 1;
    end