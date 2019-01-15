% [a, b] = getAbsPhi(refthi3, 'vertical');

% motion = motionEstimate(p8, absPhi3, 'vertical')


Ia(:,:,1) = [11, 12; 21, 22];
Ia(:,:,2) = [11, 12; 21, 22];
Ia(:,:,3) = [11, 12; 21, 22];
C(1, 1, 1) = 1.1;
C(1, 1, 2) = 1.1;
C(1, 2, 1) = 1.2;
C(1, 2, 2) = 1.6;

C(2, 1, 1) = 2.3;
C(2, 1, 2) = 1.1;
C(2, 2, 1) = 2.2;
C(2, 2, 2) = 2.2;
R = pixAggregate(Ia, C);

res = interpolate(Ia, R);
