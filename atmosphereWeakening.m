%Функция, задающая коэффициент ослабления из-за атмосферы
function atmosphereCoefficients = atmosphereWeakening(timesDistance, omega, lambda, a, I, b, cloudThickness, rainThickness)
    atmosphereCoefficients = zeros(1, length(timesDistance)); %задаём массив значений коэффициента
    i = 1;
    for time = timesDistance
        atmosphereCoefficients(i) = 10 ^ (- 0.4343 * omega / (lambda ^ 2) / 10 * cloudThickness); %ослабление в облаках
        atmosphereCoefficients(i) = atmosphereCoefficients(i) * 10 ^ (- a * I ^ b / 10 * rainThickness); %ослабление из-за дождя
        i = i + 1;
    end