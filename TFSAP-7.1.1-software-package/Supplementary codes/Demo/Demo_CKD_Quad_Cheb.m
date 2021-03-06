%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2016 Boualem Boashash
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%
% Authors: Prof. Boualem Boashash   (boualem.boashash@gmail.com)
%          Samir Ouelha             (samir_ouelha@hotmail.fr)
%          
% The following references should be cited whenever this script is used:
% [1] B. Boashash, Samir Ouelha, Designing high-resolution time-frequency
% and time-scale distributions for the analysis and  classification of non 
% stationary signals: a tutorial review with a comparison of features performance
%, Digital Signal Processing, In Press, 2017.
% [2] B. Boashash, Samir Ouelha, Efficient Software Matlab Package to compute
% Time-Frequency Distributions and related Time-Scale methods with extraction
% of signal characteristics, SoftwareX, In Press, 2017.
%
% This study was funded by grants from the ARC and QNRF NPRP 6-885-2-364
% and NPRP 4-1303-2-517 
%
%
%% Signal creation

%Quadratic signals

M=128;      % no. samples - 1
A=1;		% amplitude
fmax=0.35;	% peak freq.
B=0.2;	    % freq. range
% ANALYSIS PARAMETERS:
N=2*M;	    % padded FFT length for WVD
tres=2;	    % time resolution for WVD
% GENERATE SIGNAL:
s1 = zeros(1,M);
for n=0:M-1
    s1(n+1)=A*cos(2*pi*(fmax*n-(B/(M*M))*(((4*n/3-2*M)*n+M*M)*n)));
end

%CHEBYSHEV-5 FM


% SIGNAL PARAMETERS:
M=128;        % no. samples - 1
A=1;		% amplitude
fc=0.25;	% center freq.
fd=0.1;	% freq. deviation
% ANALYSIS PARAMETERS:
N=2*M;	% padded FFT length for WVD
tres=2;	% time resolution for WVD
% GENERATE SIGNAL:
s2 = zeros(1,M);
for n=0:M-1
    xsq=(n/M)^2;
    poly=M*((16*xsq-30)*xsq+15)*xsq/6;
    phi=2*pi*(fc*n+fd*poly);
    s2(n+1)=A*cos(phi);
end

%% TFD creation: WVD, PWVD4, PWVD6
N = M;
am1 = wvd1(s1,N); 
A = ckdKernel(1,0.2,0.15,N,N); 
am = am1.*A;
TFD_CKD = (fft(ifftshift(am,1), [], 1));
TFD_CKD = ifft(fftshift(TFD_CKD,2), [], 2);
TFD_CKD = real(TFD_CKD); TFD_CKD(TFD_CKD<0)=0;

am1 = wvd1(s2,N); 
A = ckdKernel(1,0.2,0.2,N,N); 
am = am1.*A;
TFD_CKD2 = (fft(ifftshift(am,1), [], 1));
TFD_CKD2 = ifft(fftshift(TFD_CKD2,2), [], 2);
TFD_CKD2 = real(TFD_CKD2); TFD_CKD2(TFD_CKD2<0)=0;

%% Display

FONT_TYPE='Times-Roman';
FONT_SIZE=14;
LINE_WIDTH=1.5;

fs = 1; t = 0:1:(length(s1)-1);
N = length(t); f = linspace(0,fs/2,N);

figure; imagesc(f,t,abs(TFD_CKD')) ;axis xy; set(gca, 'FontSize',12);
xlabel('Frequency (Hz)','FontName',FONT_TYPE,'FontSize',FONT_SIZE);
ylabel('Time (s)','FontName',FONT_TYPE,'FontSize',FONT_SIZE);
colormap(flipud(hot))

figure; imagesc(f,t,abs(TFD_CKD2')) ;axis xy; set(gca, 'FontSize',12);
xlabel('Frequency (Hz)','FontName',FONT_TYPE,'FontSize',FONT_SIZE);
ylabel('Time (s)','FontName',FONT_TYPE,'FontSize',FONT_SIZE);
colormap(flipud(hot))

