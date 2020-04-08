clear all
load data_qam_hfreq_24in.mat
y = y(100:end);
[r lags] = xcorr(y, x_pul);

%% 
% Collect the section of RX with MAX cross correlation and equal length with TX  
[val, idx] = max(abs(r));
% Use next line for root-raised cosine
%y_mod = y(lags(idx)+10*pulse_size:lags(idx)+10*pulse_size+1000*pulse_size);
% Use next line for square wave
y_mod = y(lags(idx):lags(idx)+1000*pulse_size);
% Only use next line for square wave
%y_mod = conv(y_mod, pulse);

%% 
% Perform DTFT to find the f_delta and phase offset
y_norm = y_mod ./rms(y_mod);
y_2= y_norm.^4;
[X, f] = plot_DTFT(y_2);
[val2, idx2] = max(abs(X));
f_loc = f(idx2)/4; %frequency offset
phase = (angle(X(idx2))+pi)/4; %phase offset

%% 
%Correct phase offset from RX
arr = 0:length(y_norm)-1;
exp_corr = exp(1j*(f_loc*floor((arr-1)/pulse_size)+phase));
y_norm_t = y_norm.';
x_rec = y_norm_t ./exp_corr;
ind = 0;
mag = 0;
for a = 1:pulse_size
    m = mean(abs(x_rec(a:pulse_size:end)));
    if(m > mag)
        ind = a;
        mag = m;
    end
end
x_rec_corr = x_rec(ind:pulse_size:end);
x_rec_corr = x_rec_corr(11:end-10);
% Only use next line for square wave
x_rec_corr = x_rec(10:20:end)
%%
f1 = figure
plot(real(data), imag(data), 'b*')
xlabel('Real')
ylabel('Imaginary')
title('Constellation of TX w/ H=3in')
%saveas(f1,'qam_3in_t.png')
f2 = figure
plot(real(x_rec_corr),imag(x_rec_corr),'r.')
xlabel('Real')
ylabel('Imaginary')
title('Demodulation Constellation w/ H=3in')
%saveas(f2,'qam_3in_r.png')
%%
x_com = [];
p_err = 1;
ph = 0;
for a = 0:15
    x_rec_corr_rot = x_rec_corr*exp(1j*a*pi/8);
    x_compare = [];
    x_compare = sign(real(x_rec_corr_rot))+1j*sign(imag(x_rec_corr_rot));
    x_compare = .2*x_compare.';
    err = x_compare - data;
    num_err = length(find(err~=0));
    error = num_err/length(data);
    if(error < p_err)
        p_err = error;
        x_com = x_compare;
        ph = a;
    end
end


     