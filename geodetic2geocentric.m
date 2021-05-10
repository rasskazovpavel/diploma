function [X, Y, Z] = geodetic2geocentric (B, L, H)
    a = 6378000;
    b = 6357000;
    e2 = (a^2 - b^2) / a^2;
    N = a / sqrt(1 - e2 * (sin(B))^2);
    X = (N + H) * cos(B) * cos(L);
    Y = (N + H) * cos(B) * sin(L);
    Z = (b^2 / a^2 * N + H) * sin(B);
end