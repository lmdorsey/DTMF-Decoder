% Copyright (c) 2015 Tinotenda Chemvura
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% 
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
% 
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.
%
% http://opensource.org/licenses/MIT
%
% -*- texinfo -*- 
% @deftypefn {Function File} {@var{retval} =} makeFrames (@var{input1}, @var{input2})
%
% @seealso{}
% @end deftypefn

%Author: Tinotenda Chemvura @tino1b2be
%Created: 2015-12-03

function out  = transformFramesZZ( frames, Fs )
% Function that decodes a given frame matrix and gives an output in the form a
% matrix with each column giving the magnitudes of the each of the DTMF 
% signals in the corresponding frame.

    dft_data = zeros(24,size(frames,2));                                            % initialise the output matrix
    % the frequency bin includes each DTMF frequency +/- 1Hz in case the
    % spectral peak is not exactly by the DTMF frequency. The frequency
    % with the highest spectral peak out of the 3 frequencies will be used
    % for further analysis
    
    % ITU Specifications : Max allowed frequency tolerance = 1.5%
    
    %freq_low = [697 +/-10, 770 +/-12, 852 +/-13, 941 +/- 14];
    %freq_high = [1209 +/-18, 1336 +/- 20, 1477 +/- 22, 1633 +/- 24];
    
    f_bin = [687:707, 758:782, 839:865, 927:955, 1191:1227, 1316:1356, 1455:1499, 1609:1657];
    
    indices = round(f_bin/Fs * length(frames)) + 1;                          % comput indices for the Goertzel calculation
    
    for i = 1:size(frames,2)
        dft_data(:,i) = abs(goertzel(frames(:,i),indices)); 
    end                                   
    
    % must choose the highest spectral peak for each DTMF frequency
    out = zeros(8,size(frames,2));
    for f = 1:size(frames,2) % for each frame
        j = 1; % frequency index in the output
        for k = 1:3:24
            out(j,f) = max(dft_data(k:k+2,f));
            j = j+1;
       end
    end
    
    for f = 1:size(frames,2) % for each frame
        out(1,f) = max(dft_data(1:21,f));       % 697Hz
        out(2,f) = max(dft_data(22:47,f));      % 770Hz
        out(3,f) = max(dft_data(48:74,f));      % 852Hz
        out(4,f) = max(dft_data(75:104,f));     % 941Hz
        out(5,f) = max(dft_data(105:142,f));    % 1209Hz
        out(6,f) = max(dft_data(143:184,f));    % 1336Hz
        out(7,f) = max(dft_data(185:230,f));    % 1477Hz
        out(8,f) = max(dft_data(231:280,f));    % 1633Hz
    end
end