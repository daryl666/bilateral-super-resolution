function [l, a, b] = rgb2lab(r, g, b)
 
R_ = invgammacorrection(r);
G_ = invgammacorrection(g);
B_ = invgammacorrection(b);

T = inv([3.2406,-1.5372,-0.4986;-0.9689,1.8758,0.0415;0.0557,-0.2040,1.057]);
R = T(1) * R_ + T(4) * G_ + T(7) * B_; %X
G = T(2) * R_ + T(5) * G_ + T(8) * B_; %Y
B = T(3) * R_ + T(6) * G_ + T(9) * B_; %Z

WhitePoint = [0.950456,1,1.088754];
X = R/WhitePoint(1);
Y = G/WhitePoint(2);
Z = B/WhitePoint(3);
fX = f(X);
fY = f(Y);
fZ = f(Z);
l = 116 * fY - 16;%L
a = 500 * (fX - fY);
b = 200 * (fY - fZ);
 
end

function R = invgammacorrection(Rp)
if Rp <= 0.0404482362771076
    R = Rp/12.92;
else
    R = real(((Rp + 0.055)/1.055).^2.4);
end
end

function fY = f(Y)
fY = real(Y.^(1/3));
if Y < 0.008856
    fY = Y * (841/108) + (4/29);
end
end

function Y = invf(fY)
fY = Fy.^3;
i = (Y < 0.008856);
Y(i) = (fY(i) - 4/29) * (108/841);
end