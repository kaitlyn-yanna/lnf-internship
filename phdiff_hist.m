%% system variables
shot = 54747;
tstart = 1067;  % 1080
tstop = 1137;
nfft = 70; % 2000;
overlap = 10; % 800;

%% calc power
% get upper data
%[time0,data0,shot,err] = TJII_getdata_web(shot,'HIBPII6',tstart,tstop);
%[time1,data1,shot,err] = TJII_getdata_web(shot,'HIBPII15',tstart,tstop);
% get lower data
%[time2,data2,shot,err] = TJII_getdata_web(shot,'HIBPII5',tstart,tstop);
%[time3,data3,shot,err] = TJII_getdata_web(shot,'HIBPII16',tstart,tstop);


% get that data b
i_stop = tstop-tstart; %+1;
time = linspace(tstart, tstop, 70);
eighteen0 = zeros(1,i_stop);
for i = 1:i_stop
    [time0,data0,shot,err] = TJII_getdata_web(shot,'HIBPII6',tstart-1+i,tstart+i);
    data0 = data0(1:end-1);
    data0 = swappy(data0);
    data = data0(1019, 1);
    eighteen0(1, i) = data;
end

eighteen1 = zeros(1,i_stop);
for i = 1:i_stop
    [time1,data1,shot,err] = TJII_getdata_web(shot,'HIBPII15',tstart-1+i,tstart+i);
    data1 = data1(1:end-1);
    data1 = swappy(data1);
    data = data1(1019, 1);
    eighteen1(1, i) = data;
end

eighteen2 = zeros(1,i_stop);
for i = 1:i_stop
    [time2,data2,shot,err] = TJII_getdata_web(shot,'HIBPII5',tstart-1+i,tstart+i);
    data2 = data2(1:end-1);
    data2 = swappy(data2);
    data = data1(1019, 1);
    eighteen2(1, i) = data;
end

eighteen3 = zeros(1,i_stop);
for i = 1:i_stop
    [time3,data3,shot,err] = TJII_getdata_web(shot,'HIBPII16',tstart-1+i,tstart+i);
    data3 = data3(1:end-1);
    data3 = swappy(data3);
    data = data1(1019, 1);
    eighteen3(1, i) = data;
end

%sum upper & lower data
i_u = eighteen0+eighteen1;
i_d = eighteen2+eighteen3;
% calculate components of delta_i
diff_i = (i_u-i_d);
sum_i = (i_u+i_d);
delta_i = diff_i./sum_i;
i_total = sum_i;

[time0,data0,shot,err] = TJII_getdata_web(shot,'HIBPII6',tstart,tstop);
deltat_ms = time0(2) - time0(1)
fs_kHz = 1/deltat_ms

% calcultate the smooth window
smoothW_ms = 1;
smoothW_points = round(smoothW_ms/deltat_ms);

%
delta_i_highpass = delta_i - smooth(delta_i, smoothW_points);
i_total_highpass = i_total - smooth(i_total, smoothW_points);

%
auxt = chopsignal(i_total_highpass, nfft, 8);
auxd = chopsignal(delta_i_highpass, nfft, 8);
fft_i_total = fft(auxt);
fft_delta_i = fft(auxd);

%fft_i_total = mean(fft(auxt)');       
%fft_delta_i = mean(fft(auxd)');
%freqs = fftfreqs(nfft, fs_kHz);
%freqs = swappy(freqs);

ph_i_t = atan(imag(fft_i_total)./real(fft_i_total));
second_i_t = (real(fft_i_total)<0) & (imag(fft_i_total)>0);
third_i_t = (real(fft_i_total)<0) & (imag(fft_i_total)<=0);

ph_d_i = atan(imag(fft_delta_i)./real(fft_delta_i));
second_d_i = (real(fft_delta_i)<0) & (imag(fft_delta_i)>0);
third_d_i = (real(fft_delta_i)<0) & (imag(fft_delta_i)<=0);

phdiff = ph_i_t-ph_d_i;
second = second_i_t - second_d_i;
third = third_i_t - third_d_i;
phase = (180/pi)*phdiff + (second - third)*pi;

figure;
p = histogram(phase,15);
