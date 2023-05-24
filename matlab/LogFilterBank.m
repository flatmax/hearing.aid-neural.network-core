classdef LogFilterBank
  % author : Matt R. Flax <flatmax@>
    properties
        fs; % Sample rate in Hz
        ft; % sTep frequency
        fc; % Central frequencies
        M; % the number of filters
        N; % the number of samples
        h; % the filters
        f; % DFT frequencies
    end

    methods

        function obj = LogFilterBank(fs, fc)
            obj.fs = fs;
            obj.fc = fc;
            if any(mod(fc,fc(1))) error('all frequencies in fc must be divisible by fc(1)'); end
            if mod(fs, fc) error('fs must be divisible by fc(1)'); end
            obj.M = length(fc);
            obj.ft = fc(1)/2;
            obj = obj.genFilters();
        end

        function obj = genFilters(obj)
            obj.N = obj.fs/obj.ft;
            obj.f = linspace(0,obj.fs,obj.N+1); obj.f(end)=[];
            fi=20;
            T=obj.N/obj.fs;
            for m=1:obj.M
                if m==1
                    fa=obj.fc(m)+(obj.ft);
                else
                    fa=obj.fc(m)+(obj.fc(m)/2);
                end
                obj.h(:,m) = ImpBandLim(T, obj.fs, fi, fa);
                obj.h(:,m) = circshift(obj.h(:,m),obj.N/2);
%                 pause
                fi=fa;
            end
        end

        function plotFilters(obj)
            figure(1); clf
            subplot(211);
            plot(obj.h); grid on; xlabel('time sample (n)'); ylabel('amp.'); title('Filter bank h_m'); axis tight
            subplot(212);
            f=obj.f; f(1)=eps;
            semilogx(f, 20*log10(abs(fft(obj.h)))); grid on; xlabel('frequency (Hz)'); ylabel('dB');
            ylim=get(gca,'ylim');
            xlim=get(gca,'xlim');
            set(gca,'xlim', [20, obj.fs], 'ylim',[ylim(1) 10]);
        end
    end
end

% Copyright (c) 2012-2023 Flatmax Pty Ltd. All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%    * Redistributions of source code must retain the above copyright
% notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above
% copyright notice, this list of conditions and the following disclaimer
% in the documentation and/or other materials provided with the
% distribution.
%    * Neither the name of Flatmax Pty Ltd nor the names of its
% contributors may be used to endorse or promote products derived from
% this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
% A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
% OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
% DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
% THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
