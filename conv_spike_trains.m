function [ Z ] = conv_spike_trains( rast, sig )
% convolve spike trains with gaussians using fft
% sig is size in time-steps 20 timesteps correpond to 2ms in the standard .1ms sampling
% lenght of rast
[N, l] = size(rast);

x = [-5*sig:1:5*sig]';  % x-axis values of the discretely sampled Gaussian, out to 5xSD
h = (1/(sqrt(2*pi*sig^2)))*exp(-((x.^2*(1/(2*sig^2))))); % y-axis values of the Gaussian

H = fft(h,l); %FFT of gaussian signal h

rast_fft = fft(full(rast>0)'); % FFT of all spike trains

c_rast_fft = rast_fft.*repmat(H,1,N); % convolve each spike train with gaussian in FT domain
Z = ifft(c_rast_fft,'symmetric')';  % go back to time domain
% Z is a node x time-steps matrix containing the gaussian convolved
% time-signals of a neuron in each row

% normalise all rows to have unit integral
% d = sum(rast>0,2);
% d(d==0)=1;
% Z= diag(d)\Z;


end

