clc;
clear;
load('DNA300mhzoffset5dn_45gr_0.1step.mat'); %загружаем матрицу диаграммы направленности
receiverGeodetGrad = [25.4848, 30.036, 0]; %координаты приёмника в геодезических координатах (в градусах)
objectGeodetGrad = [25.0465, 29.2172, 621970]; %координаты космического объекта в геодезических координатах (в градусах)
receiverGeodetRad = [deg2rad(receiverGeodetGrad(1)), deg2rad(receiverGeodetGrad(2)), receiverGeodetGrad(3)]; %координаты приёмника в геодезических координатах (в радианах)
objectGeodetRad = [deg2rad(objectGeodetGrad(1)), deg2rad(objectGeodetGrad(2)), objectGeodetGrad(3)]; %координаты космического объекта в геодезических координатах (в градусах)
timeStart = 0; %время начала моделирования
timeFinish = timeStart + 180; %время окончания моделирования
VObject = DNA0; %диаграмма направленности космического объекта
VReceiver = DNA0; %диаграмма направленности приёмника
timesEmit = 1:180; %времена излучения импульсов (какая-то функция, пока просто импульсы с интервалом в 1 с)
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
amplitude = 1; %амплитуда сигнала
frequencyStart = 0; %начальная частота сигнала
frequencyEnd = 5 * 10^6; %конечная частота сигнала
timeImpulse = 10 * 10^(-6); %длительность импульса
times = 0:10^(-8):0+timeImpulse; %период дискретизации


signal = zeros(1, length(times) * length(timesEmit)); %массив отсчётов сигнала
ti = zeros(1, length(times) * length(timesEmit)); %массив отсчётов времени

count = 1;
for time = timesEmit %цикл по всем единичным сигналам
    tau = sqrt(sum((receiverGeocen - objectGeocen - objectVelocity * time) .^ 2)) / c; %задержка

    tiElem = time + times + tau; %отсчёты времени, когда сигнал приходит на приёмник
    signalElem = acceptedSignal(amplitude, frequencyStart, frequencyEnd, timeImpulse, times); %сигнал в эти отсчёты времени
    %plot(tiElem, signalElem);
    
    for i = 1:length(times) %заносим полученные выше массивы в один общий
        ti(count) = tiElem(i);
        signal(count) = signalElem(i);
        count = count + 1;
    end
   
    wD = weakeningDistance(receiverGeocen, objectGeocen + objectVelocity * time); %коэффициент ослабления из-за дальности
    wA = weakeningAtmosphere(timeStart); %коэффициент ослабления из-за атмосферы
    VqObject = objectPattern(VObject, receiverGeocen, objectGeocen + objectVelocity * time, objectVelocity); %коэффициент, учитывающий ДН объекта
    VqReceiver = receiverPattern(VReceiver, receiverGeocen, objectGeocen + objectVelocity * time); %коэффициент, учитывающий ДН приёмника
    
    result = wD * wA * signal * VqObject * VqReceiver; %итоговый сигнал
end

plot(ti, result); %график зависимости сигнала на приёмнике от времени моделирования
title ('График зависимости сигнала на приёмнике от времени');
xlabel('Время');
ylabel('Сигнал на приёмнике');
