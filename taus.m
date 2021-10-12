%Функция, вычисляющая значения задержки сигнала в зависимости от сигнала
function delays = taus(times,receiverGeocen, objectGeocen, objectVelocity)
    c = 3 * 10^8; %скорость света
    delays = zeros(1, length(times)); %объявляем массив значений задержки
    count = 1;
    for time = times
        delays(count) = sqrt(sum((receiverGeocen - objectGeocen - objectVelocity * time) .^ 2)) / c; %ищем значение задержки
        count = count + 1;
    end