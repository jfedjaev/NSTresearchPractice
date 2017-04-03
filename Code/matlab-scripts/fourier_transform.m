function fourier_transform(Fs,x)
% period of the signal 
T= 1/Fs; 
% length of the signal 
L= length(x); 
% time vector 
t= (0:L-1)*T; 
% plot the signal in the time domain 

plot (t, x); 
title ('Signal in time domain'); 
xlabel = ('milliseconds');
ylabel = ('X(t)'); 

% plot the signal in the frequency domain 
% compute fft 
y = fft(x); 
% compute the magnitude 
P2 = abs (y/L); 
% take the odd and even values 
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
% frequency vector till Fs/2 
f = Fs*(0:(L/2))/L;
% plot 
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')

end

% here the function does not return anything! 