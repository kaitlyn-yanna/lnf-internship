fs = 1000; % 8192; Sampling frequency (samples per second)
dt = 1/fs; % seconds per sample
% StopTime = 1.00 - dt; % 1.00
t = 0:dt:1-dt; % (0:dt:StopTime)';
tsize = size(t);
F = 10;
rng1 = randn(tsize);
rng2 = randn(tsize);
noise1 = rng1;
noise2 = rng2;
setphase = 0.25*pi;
x = sin(2*pi*F*t) + noise1;
y = sin(2*pi*F*t + setphase) + noise2;

points = 10; % points per window
%auxt = chopsignal(x, points, 8);
%auxd = chopsignal(y, points, 8);
fft_i_total = fft(x); %fft(auxt);
fft_delta_i = fft(y); %fft(auxd);

xpower = fft_delta_i.*conj(fft_i_total);
phdiff = atan(imag(xpower)./real(xpower));
second = (real(xpower)<0) & (imag(xpower)>0);
third = (real(xpower)<0) & (imag(xpower)<=0);
phase = (180/pi)*phdiff + (second - third)*pi;
%phase = atan2(imag(xpower),real(xpower));
%av_phase = mean(phase);
phDiff = swappy(phase);
freqs = fftfreqs(1000, fs);
freqs = swappy(freqs);

[Cxy,F] = mscohere(x,y,hamming(100),80,100,fs);
figure;
plot(F, Cxy)

figure;
subplot(2, 1, 1)
plot(freqs, phDiff)
xlim([0,500])
title('Phase difference vs frequency of delta I and I total')
subplot(2, 1, 2)
yyaxis left
plot(freqs, phDiff)
hold on
yyaxis right
plot(F, Cxy)
hold off
xlim([0,100])
xlabel('Frequency (kHz)')
ylabel('Phase difference (degrees)')