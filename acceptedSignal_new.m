%Функция, моделирующая ЛЧМ сигнал
function signal = acceptedSignal_new(amplitude, frequencyStart, frequencyEnd, timeImpulse, times, periodEmit)
    signal = zeros(1, length(times)); %задаём массив значений сигнала 
    coefficient = (frequencyEnd - frequencyStart) / timeImpulse; %находим коэффициент пропорциональности
    count = 1;
    for time = times
        t = time;
        while (t >= periodEmit) %учитываем периодичность сигнала
            t = t - periodEmit;
        end
        if t <= timeImpulse %учитываем длительность импульса
            signal(count) = amplitude * sin(pi * coefficient * t^2);
        end
        count = count + 1;
    end
end