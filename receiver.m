%функция, задающая матрицу диаграммы направленности антенны приёмника
function receiver = receiver(range, step)
[x, y] = meshgrid(-range:step:range);
r = sqrt(x.^2 + y.^2);
receiver = sinc(r);