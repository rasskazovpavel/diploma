%Функция, вычисляющая значения задержки сигнала в зависимости от сигнала
function delays = taus(timesTau,receiverGeocen, objectGeocen, objectVelocity)
    c = 3 * 10^8; %скорость света
    delays = zeros(1, length(timesTau)); %объявляем массив значений задержки
    count = 1;
    for time = timesTau
        delays(count) = sqrt(sum((receiverGeocen - objectGeocen - objectVelocity * time) .^ 2)) / c; %ищем значение задержки
        count = count + 1;
    end