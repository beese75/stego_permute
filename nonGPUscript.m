function nonGPUscript()
% SCRIPT for 535 Project - Zachary Beese
% Non-GPU script

% Test Parameters
NITERS=[1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536];

% Read Cover Image
img = imread('img.jpg');

% Get Image Specs
[m n] = size(img);
sz = m*n;
for NITER=NITERS
% Seed RNG
rng(1234);
RATES = [10 25 50];

for embedRate = RATES
% Setup Message as a logical GPU Array
M = round(rand(floor(embedRate*sz/100),1));
M = logical(M);
fprintf(1, "M is %d bits, IMG is %d bits\n", length(M), 8*sz);

% Set as Vector for manipulation
stego = reshape(img,[sz 1]);

% Setup to pull off the LSBs
stegolsb = zeros(length(stego),1,'logical');

% Pull out the LSBs of the cover
for (j=1:length(stego))
    stegolsb(j) = bitget(stego(j),1);
end

% TEST ARGUMENTS
numGroups = [1 2 4 8 16 32 64 128 256 512 1024 2048];

% TEST RESULTS
totalBits = [0 0 0 0 0 0 0 0 0 0 0 0];
elapsedTimes = [0 0 0 0 0 0 0 0 0 0 0 0];

% Initializations
iterNum = 0;
for iter = numGroups
    iterNum = iterNum + 1;
    
    % Timing Assessment
    tic;
    
    % Initialize array to hold each iteration's bit embedding count
    X=zeros(1,iter);
    
    % Loop over block counts (1 2 4 8 16...1024)
    for x=1:iter
        % Calculate indices into M and the cover for processing
        i1 = 1+(round((x-1)*((length(stegolsb)/iter))));
        i2 = x*round((length(stegolsb)/iter));
        if i2 > length(stegolsb)
            i2 = length(stegolsb);
        end
        i3 = 1+(round((x-1)*(length(M)/iter)));
        i4 = x*round((length(M)/iter));
        if i4 > length(M)
            i4 = length(M);
        end
    
        changedBits = zeros(NITER,1);
        
        parfor (i=1:NITER)
            changedBits(i) = checkLSB(stegolsb(i1:i2),M(i3:i4));            
        end
    
        [minChangedBits,RPval] = min(changedBits);
        %fprintf(1,"%d - FINAL:  min: %d, RPval: %d\n",x,minChangedBits,RPval);
        X(x) = minChangedBits;
    end
    elapsedTimes(iterNum) = toc;
    totalBits(iterNum) = sum(X);    
    fprintf(1,"\n%d - GRAND FINAL: Total Bits Changed:  %d  Percent: %d\n",iter,sum(X),sum(X)/length(M)); 
end
savName = sprintf("lsbTest-%d-%d-%d-%s.mat",NITER,embedRate,iter,datetime('now', 'Format','HHmmss'));
save(savName);
end
end
end