%% system variables
shot = 54747;
tstart = 1067;  % 1080
tstop = 1137;
nfft = 2000;

%% calc power
% get upper data
[time0,data0,shot,err] = TJII_getdata_web(shot,'HIBPII6',tstart,tstop);
[time1,data1,shot,err] = TJII_getdata_web(shot,'HIBPII15',tstart,tstop);
% get lower data
[time2,data2,shot,err] = TJII_getdata_web(shot,'HIBPII5',tstart,tstop);
[time3,data3,shot,err] = TJII_getdata_web(shot,'HIBPII16',tstart,tstop);
%sum upper & lower data
i_u = data0+data1;
i_d = data2+data3;
% calculate components of delta_i
diff_i = (i_u-i_d);
sum_i = (i_u+i_d);
delta_i = diff_i./sum_i;
i_total = sum_i;

deltat_ms = time0(2) - time0(1)
fs_kHz = 1/deltat_ms

% calcultate the smooth window
smoothW_ms = 1;
smoothW_points = round(smoothW_ms/deltat_ms);

%
delta_i_highpass = delta_i - smooth(delta_i, smoothW_points);
i_total_highpass = i_total - smooth(i_total, smoothW_points);

%
auxt = chopsignal(i_total_highpass, nfft, 800);
auxd = chopsignal(delta_i_highpass, nfft, 800);
fft_i_total = mean(fft(auxt)');       
fft_delta_i = mean(fft(auxd)');
freqs = fftfreqs(nfft, fs_kHz);
freqs = swappy(freqs);

%{
%% plot periodograms
% delta i 
figure;
subplot(2,1,1)
fft_data = swappy(fft_delta_i);
semilogy(freqs, abs(fft_data));
title('Periodogram of Delta I using FFT')
xlim([0, 1000])
grid on
subplot(2,1,2)
semilogy(freqs, abs(fft_data));
xlim([0,100])
xlabel('Frequency (Hz)')
grid on

[~, freq] = max(fft_data);
disp('Max power corresponds to')
disp(freqs(1, freq))

% total i 
figure;
subplot(2,1,1)
fft_data = swappy(fft_i_total);
semilogy(freqs, abs(fft_data));
title('Periodogram of I Total using FFT')
xlim([0, 1000])
grid on
subplot(2,1,2)
semilogy(freqs, abs(fft_data));
xlim([0,100])
xlabel('Frequency (Hz)')
grid on

[~, freq] = max(fft_data);
disp('Max power corresponds to')
disp(freqs(1, freq))
%}

%{
%% xpower
fft1 = fft_delta_i;
fft2 = fft_i_total;
xpowershift = abs(fft1).*abs(fft2); %(1/(2000*N))*((conj(fft1).*fft2));
[~, freq] = max(xpowershift);
disp('Max xpower corresponds to')
disp((freqs(1, freq)))
xpower = swappy(abs(xpowershift));
figure;
subplot(2,1,1)
semilogy(freqs, xpower)
xlim([0, 1000])
grid on
title(['Cross Power Spec of delta I & Total I, shot: ',num2str(shot)],'Interpreter','none');
subplot(2,1,2)
semilogy(freqs, xpower)
xlim([0,100])
xlabel("Frequency (Hz)")
grid on
%}

%% coherence

% get background coherence

% Bendat and Piersol have a formula for statistical significance and you can use that to set a cutoff?
% take one time history and artificially shift it by a # of data points - 1/1MHz 
%and then correlate shifted and x2 therefore 0 correlation, there is a finite level not equal to 0 to find correlated noise, anything above this noise is real, emprirical (0.2)
% A modified method of calculating cross-power spectra has been developed to extract fluctuation data from core measurements. 
%Since the electronic and photon noise are un- correlated between channels, taking the cross power largely eliminates these contributions to the signal. 
%However, the cross-power between two random data sets with no shared signal at all still results in a finite, nonzero power. 
%This offset from zero cross power arises from numerical bias errors in calculating the cross power, which is always a positive-

%auxdd = randn(size(auxd), 'like', auxd);
%auxtt = randn(size(auxt));
%auxdd = randn(size(auxd));
%auxtt = swappy(auxt);
auxtt = zeros(size(auxt));

for i = 1:114
    auxtt(:,1) = auxt(:,116);
    auxtt(:,2) = auxt(:,115);
    auxtt(:,i+2) = auxt(:,i);
end

auxtt = auxt;
auxdd = auxd;
fft_t = fft(auxtt);
fft_d = fft(auxdd);

product = fft_t.*conj(fft_d);
num_cohere = abs(mean(product'));
fft_t_abs = abs(fft_t);
fft_d_abs = abs(fft_d);
denom_cohere = sqrt((mean((fft_t_abs.*fft_t_abs)')).*(mean((fft_d_abs.*fft_d_abs)')));
bknd_coherence =  num_cohere./denom_cohere;
%freqs = fftfreqs(nfft, fs_kHz);
mean_val = mean(bknd_coherence, 'all');
disp('mean val')
disp(mean_val)

figure;
plot(freqs, bknd_coherence)
title('background coherence')
xlabel('Frequency (kHz)')
xlim([0,1000])
grid on


% get real coherence 

% make it a hanning window time
h = hann(nfft);
h_auxt = h.*auxt;
h_auxd = h.*auxd;

fft_t = fft(h_auxt);  % overlapping and hanning window???
fft_d = fft(h_auxd);  % overlapping and hanning window???

product = fft_t.*conj(fft_d);
num_cohere = abs(mean(product'));
fft_t_abs = abs(fft_t);
fft_d_abs = abs(fft_d);
denom_cohere = sqrt((mean((fft_t_abs.*fft_t_abs)')).*(mean((fft_d_abs.*fft_d_abs)')));
coherence =  num_cohere./denom_cohere;

figure;
sgtitle('Total I & Delta I Magnitude-Squared Coherence','fontweight','bold')

subplot(2,2,1)
noverlap = 800;
[Cxy,F] = mscohere(i_total_highpass,delta_i_highpass,hann(nfft),noverlap,nfft,fs_kHz,'mimo');
%[Cxy,F] = mscohere(i_total_highpass,delta_i_highpass,fs_kHz);
plot(F,Cxy)
title('mscohere')
ylim([0,1])
xlabel('Frequency (kHz)')
xlim([0,1000])
grid on

subplot(2,2,3)
%freqs = swappy(freqs);
coherence = swappy(coherence);
plot(freqs, coherence)
title('van Milligen')
xlabel('Frequency (kHz)')
xlim([0,1000])
ylim([0,1])
grid on

subplot(2,2,2)
plot(F,Cxy)
title('Close up of mscohere')
ylim([0,1])
xlabel('Frequency (kHz)')
xlim([0,100])
grid on

subplot(2,2,4)
plot(freqs, coherence)
xlabel('Frequency (kHz)')
title('Close up of van Milligen')
grid on
xlim([0,100])
ylim([0,1])

%% phase difference
X = fft(auxt);
Y = fft(auxd);

% old phase difference estimation
%{
PhDiff = angle(Y) - angle(X); 
%fprintf('measured phase difference: %d radians \n', PhDiff); 
figure;
plot(freqs, (180/pi)*PhDiff)
title('old way of calculating phdiff')
xlim([0,1000])
xlabel('Frequency (kHz)')
ylabel('Phase difference (degrees)')
grid on
%}
points = 70;
figure;
auxt = chopsignal(i_total_highpass, points, 0);
auxd = chopsignal(delta_i_highpass, points, 0);
X = fft(auxt);
Y = fft(auxd);
xpower = X.*conj(Y);
phDiff = (180/pi)*atan(imag(xpower)./real(xpower));
second = (real(xpower)<0) & (imag(xpower)>0);
third = (real(xpower)<0) & (imag(xpower)<=0);
phase = (180/pi)*phDiff + (second - third)*pi;
av_phase = mean(phase);
phDiff = swappy(av_phase);
subplot(2, 1, 1)
plot(freqs, mean_phDiff)
xlim([0,1000])
title('Phase difference vs frequency of delta I and I total')
subplot(2, 1, 2)
plot(freqs, mean_phDiff)
xlim([0,100])
xlabel('Frequency (kHz)')
ylabel('Phase difference (degrees)')


% weighted phase difference
%{
figure;
delta_i = mean(auxd');
total_i = mean(auxt');
wPhDiff = abs(delta_i).*abs(total_i).*PhDiff;
plot(freqs, wPhDiff)
xlim([0,1000])
xlabel('Frequency (kHz)')
ylabel('Phase difference (degrees)')
title('Weighted phase difference vs frequency of delta I and I total')

% the actual weighted phase difference that i used
figure;
delta_i = mean(auxd');
total_i = mean(auxt');
%wphDiff = abs(delta_i).*abs(total_i).*phDiff;
wphDiff = coherence.*phDiff;
plot(freqs, wphDiff)
xlim([0,1000])
xlabel('Frequency (kHz)')
ylabel('Phase difference (degrees)')
title('Newer weighted phase difference vs frequency of delta I and I total')


% coherence and phase difference subplotted
figure;
subplot(2, 1, 1)
plot(freqs, coherence)
xlim([0,1000])
title('coherence')
grid on
subplot(2, 1, 2)
plot(freqs, PhDiff) % convert y to degrees; find a better way to graph this 
xlim([0,1000])
title('phase diff')
xlabel('Frequency (kHz)')
grid on
%}

%l_cohere =

% only plot phase differences for a coherence > mean bknd coherence
selec_pd = zeros(1, nfft);
for i = 1:length(coherence)
    if coherence(1, i) > bknd_coherence(1,i) % mean_val
        selec_pd(1,i) = phDiff(1,i); 
        
    end
    %disp(coherence(1, 1019))
end

figure;
newcolors = [ 0 0.4470 0.7410; 0.9290 0.6940 0.1250; 0.8500 0.3250 0.0980; 0.4660 0.6740 0.1880; 0.4940 0.1840 0.5560; 0.6350 0.0780 0.1840];
colororder(newcolors)
yyaxis left
plot(freqs, coherence)
xlim([0,1000])
ylim([0,1])
ylabel('Coherence [normalized to 1]')
yyaxis right
scatter(freqs, selec_pd)
ylim([-90,90])
ylabel('Phase Difference [degrees]')
title('Coherence & Meaningful Phase Difference')
xlabel('Frequency [kHz]')
