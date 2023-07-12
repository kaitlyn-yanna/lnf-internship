function [M, centers] = chopsignal(x, window, overlap)
%   Takes a signal x and chops it in as many windows of 'window' points length and
%   overlaped points 'overlap' as possible. The output is a matrix of parts of the
%   signal in the columns so that, for instance, S = skewness(M) is a 1D
%   signal with the skewness of each of the signal windows.
%
%   upon further investigation, it was found that 'window' is not actually
%   the number of windows, but the number of points in such a window. thus
%   when overlap = 0, actual_window = length(x)/window
%
%    M = chopsignal(x, window, overlap)
%
%   Examples:
%
%   imagesc(abs(fft(M)) % is a spectrogram


if overlap > window; overlap = window - 1; end

starts = 1:(window - overlap):(length(x) - window + 1); 

M = zeros(window, length(starts));


for i=1:length(starts)
    M(:,i) = x(starts(i):starts(i) + window -1);
end

centers = starts + round(.5*window);
end