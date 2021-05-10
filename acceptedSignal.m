%Функция, моделирующая ЛЧМ сигнал
function signal = acceptedSignal(amplitude, frequencyStart, frequencyEnd, timeImpulse, t)
    coefficient = (frequencyEnd - frequencyStart) / timeImpulse;
    signal = amplitude * sin(pi * coefficient * t.^2);
end