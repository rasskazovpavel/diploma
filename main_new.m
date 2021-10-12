clc;
clear;
load('DNA300mhzoffset5dn_45gr_0.1step.mat'); %загружаем матрицу диаграммы направленности
receiverGeodetGrad = [25.4848, 30.036, 0]; %координаты приёмника в геодезических координатах (в градусах)
objectGeodetGrad = [25.0465, 29.2172, 621970]; %координаты космического объекта в геодезических координатах (в градусах)
receiverGeodetRad = [deg2rad(receiverGeodetGrad(1)), deg2rad(receiverGeodetGrad(2)), receiverGeodetGrad(3)]; %координаты приёмника в геодезических координатах (в радианах)
objectGeodetRad = [deg2rad(objectGeodetGrad(1)), deg2rad(objectGeodetGrad(2)), objectGeodetGrad(3)]; %координаты космического объекта в геодезических координатах (в градусах)
VObject = DNA0; %диаграмма направленности космического объекта
VReceiver = receiver(5, 0.05); %диаграмма направленности приёмника
c = 3 * 10^8; %скорость света
objectVelocity = [-1000, -1000, 2000]; %скорость спутника

%Переходим в геоцентрическую систему с помощью написанной функции
[receiverX, receiverY, receiverZ] = geodetic2geocentric(receiverGeodetRad(1), receiverGeodetRad(2), receiverGeodetRad(3));
[objectX, objectY, objectZ] = geodetic2geocentric(objectGeodetRad(1), objectGeodetRad(2), objectGeodetRad(3));

receiverGeocen = [receiverX, receiverY, receiverZ];
objectGeocen = [objectX, objectY, objectZ];

%Переходим в геоцентрическую систему с помощью библиотечной функции

wgs84 = wgs84Ellipsoid('meter');

[xr, yr, zr] = geodetic2ecef(wgs84, 25.4848, 30.036, 0);
[xo, yo, zo] = geodetic2ecef(wgs84, 24.0465, 29.2172, 621970);

%Как видно, библиотечная и написанная руками функции работают одинаково

%Моделируем ЛЧМ сигнал
timeStart = 0; %время начала моделирования
timeFinish = timeStart + 0.0001; %время окончания моделирования
periodEmit = 3 * 10^(-4); %период между импульсами
amplitude = 10 ^ 50; %амплитуда сигнала
frequencyStart = 0; %начальная частота сигнала
frequencyEnd = 10^8; %конечная частота сигнала
timeImpulse = 10^(-4); %длительность импульса
timesEmit = timeStart:periodEmit:timeFinish; %времена излучения импульсов
times = 0:5*10^(-9):0+timeFinish; %период дискретизации для сигнала
timesDelay = times; %времена принятия сигнала с учётом задержки
%timesDistance = 0:3*10^(-4):0+timeFinish; %период дискретизации для расстояний
%timesTau = 0:4*10^(-6):0+timeFinish; %период дискретизации для задержки

delays = taus(times, receiverGeocen, objectGeocen, objectVelocity); %массив значений задержки

%находим в цикле для каждого отсчёта времени для сигнала соответствующую задержку
for i = 1:length(times)
    timesDelay(i) = times(i) + delays(i); %прибавляем задержку к времени отсчёта сигнала
end

distancesArray = distances(times, receiverGeocen, objectGeocen, objectVelocity); %массив значений расстояния между спутником и приёмником
coefficients = 1 ./ (4 * pi * distancesArray); %массив значений коэффициента ослабления из-за расстояния
coefficients = coefficients .* objectWeakening(VObject, receiverGeocen, objectGeocen, objectVelocity, times); %добавляем коэффициент ослабления из-за диаграммы направленности объекта
coefficients = coefficients .* receiverWeakening(VReceiver, receiverGeocen, objectGeocen, objectVelocity, times, wgs84); %добавляем коэффициент ослабления из-за диаграммы направленности приёмника

omega = 1 * 10 ^ (-3); %водность в облаках
lambda = 3 * 10 ^ (-2); %длина волны
I = 50; %интенсивность осадков [мм/ч]
a = 0.0074; %эмпирическая величина
b = 1.31; %эмпирическая величина
cloudThickness = 10; %толщина облаков
rainThickness = 10; %толщина дождевого слоя

atmosphereCoefficients = atmosphereWeakening(times, omega, lambda, a, I, b, cloudThickness, rainThickness); %коэффициент ослабления из-за атмосферы
coefficients = coefficients .* atmosphereCoefficients; %обновляем значения массива коэффициентов

signalTimes = acceptedSignal_new(amplitude, frequencyStart, frequencyEnd, timeImpulse, timesDelay, periodEmit); %задаём массив значений сигнала
times = 0:5*10^(-9):0+timeFinish; %задаём массив отсчётов времени для сигнала
count = 1;

%находим в цикле для каждого отсчёта времени для сигнала соответствующее значение коэффициента ослабления
for i = 1:length(times)
    signalTimes(i) = signalTimes(i) * coefficients(i); %умножаем значение сигнала на соответствующий коэффициент
end

plot(times, signalTimes);
