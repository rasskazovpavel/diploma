%Коэффициент, учитывающий диаграмму направленности приёмника
function VqReceiver = receiverPattern(VReceiver, receiverLocation, objectLocation)
    %находим максимальный элемент в матрице диаграммы направленности и его
    %индекс
    [maxVal, maxInd] = max(VReceiver);
    %добавляем случайные ошибки в пределах 1 градуса по двум направлениям
    phiError = randi([-10, 10]);
    thetaError = randi([-10, 10]);
    VqReceiver = VReceiver(maxInd(1) + phiError, maxInd(2) + thetaError);
end