%% system variables
shot = 54747;
tstart = 1067;  % 1080
tstop = 1137;
%nfft = 70; % 2000;
%overlap = 10; % 800;


%% get that data b 
% the for loop below gets the data point that corresponds to 18 Hz from 
% every shot and adds it to an array

%{
i_stop = tstop-tstart; %+1;
time = linspace(tstart, tstop, 70);
eighteen0 = zeros(1,i_stop);
eighteen1 = zeros(1,i_stop);
eighteen2 = zeros(1,i_stop);
eighteen3 = zeros(1,i_stop);
for i = 1:i_stop
    [time0,data0,shot,err] = TJII_getdata_web(shot,'HIBPII6',tstart-1+i,tstart+i);
    data0 = data0(1:end-1);
    data0 = swappy(data0);
    data = data0(1019, 1);
    eighteen0(1, i) = data;
end
for i = 1:i_stop
    [time1,data1,shot,err] = TJII_getdata_web(shot,'HIBPII15',tstart-1+i,tstart+i);
    data1 = data1(1:end-1);
    data1 = swappy(data1);
    data = data1(1019, 1);
    eighteen1(1, i) = data;
end
for i = 1:i_stop
    [time2,data2,shot,err] = TJII_getdata_web(shot,'HIBPII5',tstart-1+i,tstart+i);
    data2 = data2(1:end-1);
    data2 = swappy(data2);
    data = data2(1019, 1);
    eighteen2(1, i) = data;
end
for i = 1:i_stop
    [time3,data3,shot,err] = TJII_getdata_web(shot,'HIBPII16',tstart-1+i,tstart+i);
    data3 = data3(1:end-1);
    data3 = swappy(data3);
    data = data3(1019, 1);
    eighteen3(1, i) = data;
end
%}
% this data is taken from the above
eighteen0 = [    2.2270    2.4449    1.3138    0.5663    0.6767    1.7933    2.2889    1.6542    1.2866    1.5511    2.0500    1.6624    0.6482    0.4703    0.4388    0.5960    1.5054    2.5002    2.1788    1.5504    1.9725    2.1050    2.4142    1.0853    0.4988    1.3216    1.9178    2.0497    1.5489    1.6364    2.0269    2.2804    1.2078    0.6263    0.3816    0.4578    0.7320    2.0850    2.2210    1.5926    1.7543    2.1297    2.3945    1.5451    0.5616    0.6442    1.9719    2.4052    1.9950    1.4129    1.6617    2.0810    1.7896    0.7229    0.4153    0.4056    0.6098    1.5998    2.2041    1.7317    1.5811    1.8752    2.3195    2.2166    1.0056    0.5326    1.3347    2.0269    2.1303    1.4882];
eighteen1 = [    1.9460    2.1611    1.3317    0.6213    0.6191    1.5385    2.3217    2.2179    2.0945    1.8729    2.1336    2.1523    0.9822    0.4244    0.4038    0.5491    1.3120    1.5895    1.8276    1.6270    1.8642    2.4605    2.2808    0.9401    0.5241    0.9457    2.7133    2.2204    2.1589    1.5651    1.8435    1.9526    1.3951    0.5363    0.4060    0.4719    0.9838    1.7073    1.8657    1.7138    1.8304    1.9008    2.4970    1.5532    0.8050    0.7369    1.7723    2.2358    2.0292    1.9979    1.7292    1.9951    1.9551    0.8935    0.4500    0.4097    0.5704    1.2829    1.7048    1.8589    1.5345    2.1432    2.3023    2.2605    0.9172    0.4513    0.9132    2.7661    2.4452    1.7395];
eighteen2 = [    0.5362    0.7749    0.6648    0.4696    0.5125    0.8799    0.8155    0.5828    0.4637    0.5663    0.7874    0.8096    0.4962    0.4440    0.4171    0.4921    0.7795    1.0707    0.7699    0.5337    0.5588    0.7686    1.0463    0.6860    0.4565    0.8014    0.9240    0.7989    0.5325    0.5447    0.8264    0.9825    0.6982    0.4778    0.4177    0.4690    0.5450    0.9694    0.9037    0.6179    0.5710    0.8155    1.1157    0.8993    0.4968    0.5644    1.0422    1.1163    0.7380    0.5403    0.6785    0.9290    0.8953    0.5584    0.4296    0.4133    0.5222    0.8702    0.9931    0.7580    0.6185    0.6720    1.0097    1.1479    0.6989    0.4737    0.8637    1.0507    0.9681    0.6454];
eighteen3 = [    0.4501    0.6186    0.5820    0.4761    0.4801    0.6564    0.7048    0.5808    0.4348    0.4645    0.5892    0.6898    0.4980    0.4389    0.4223    0.4230    0.5501    0.5464    0.5439    0.4398    0.5511    0.7310    0.8304    0.5579    0.4148    0.5739    0.9460    0.7007    0.5239    0.4226    0.5633    0.6532    0.6061    0.4158    0.4008    0.4186    0.5298    0.6379    0.5957    0.4655    0.4764    0.6357    0.9254    0.7723    0.5183    0.5086    0.8451    0.8810    0.6701    0.4673    0.5523    0.6707    0.7235    0.5179    0.4148    0.4002    0.4598    0.6126    0.6592    0.5583    0.4858    0.6429    0.8373    0.9604    0.5751    0.4436    0.5686    1.0904    0.8798    0.6139];
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

% get to the same size
delta_i = delta_i';
i_total = i_total';

%
delta_i_highpass = delta_i - smooth(delta_i, smoothW_points);
i_total_highpass = i_total - smooth(i_total, smoothW_points);

%

points = 10; % points per window
auxt = chopsignal(i_total_highpass, points, 8);
auxd = chopsignal(delta_i_highpass, points, 8);
fft_i_total = fft(auxt);
fft_delta_i = fft(auxd);

xpower = fft_delta_i.*conj(fft_i_total);
phdiff = atan(imag(xpower)./real(xpower));
second = (real(xpower)<0) & (imag(xpower)>0);
third = (real(xpower)<0) & (imag(xpower)<=0);
phase = (180/pi)*phdiff + (second - third)*pi;
av_phase = mean(phase);

figure;
p = histogram(av_phase,15);
title('Histogram of Phase difference')
%subtitle(['# of points averaged together: ' int2str(points)])
xlabel('Phase difference [degrees]')
