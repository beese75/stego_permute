function changerate = checkLSB(stegolsb,M)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
changerate = 0;

% Permute stego keyperm times
persistent seq;
%tseq = gpuArray(seq);
%tstego=gpuArray(stegolsb);
%tseq = randperm(length(tstego));
%seq = gather(tseq);
%stegolsb = gather(tstego);
%stegolsb = stegolsb(seq);
seq = randperm(length(stegolsb));
stegolsb = stegolsb(seq);

% I chose to embed by clearing LSB in stego, then set/clear based on M
% I would have preferred to just AND with 0xfe [clear bit] and OR with M
% But this appears to work just fine

%tM = gpuArray(M);
%tstego = gpuArray(stego);
Z = xor(stegolsb(1:length(M)), M);

%for (i=1:(length(M)))
%    if(Z(i))
%        changerate = changerate + 1;
%    end
%end
changerate = sum(Z);
%M = gather(tM);
%stego=gather(tstego);
% Calculate chisq for lengths from 1% to 100% of stego
% Leaving element 1 at zero since it would be a chisq of 0
%for j=1:100
%    y = chisq(stego(1:floor(sz*j/100)));
%    pgraph(j+1) = y;
%end
%deseq(seq) = 1:length(seq);
%stegolsb = stegolsb(deseq);
