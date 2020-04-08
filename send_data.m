clear all
N = 1000;
pulse_size = 20;
data = .2*sign(randn(N, 1))+1j*.2*sign(randn(N,1));
x_u = upsample(data, pulse_size);

%%
% Design pulse shape
pulse = ones(pulse_size, 1);
%pulse = rcosdesign(0.5, 20, pulse_size, 'sqrt');

%%
x_pul = conv(x_u, pulse);
x = [zeros(1000, 1); x_pul; zeros(1000, 1)];
write_usrp_data_file(x);
%plot(real(x), imag(x), 'b*')
%figure
%stem(x)