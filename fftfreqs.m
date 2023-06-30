function f = fftfreqs(nfft, fs)
    %   computes the freqencies associated to the fft coeficients  
    %   i.e:
    %       X = fft(x, 512);
    %       f = fftfreqs(512, 2e6);
    %       plot(f, abs(X), 'o');
    %   where nfft is the length of the signal
    disp('nfft: ')
    disp(nfft)
    %nfft = 2000;
    if mod(nfft,2) ~= 0
        error('fftfreqs works only for even nfft')
    end
    f = fftshift(-.5*nfft : .5*nfft - 1)*fs/nfft;  % zero-centered frequency range
    %fshift = (1:n)*(obj.fs/n);
end