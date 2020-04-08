function [X, f] = plot_DTFT(x);
% plots DTFT of signal

N = length(x);

X = fftshift(fft(x));
f = linspace(-pi, pi-(2*pi/(N+1)), N);
figure
plot(f, abs(X));
xlabel('f')
ylabel('abs(X)')
title('DTFT of squared and normalized RX')
end