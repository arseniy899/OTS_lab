%% p1. HARD

Common.SaveDirName = 'L1P1';
Encoder.isTransparent = false;
Encoder.Type = 'conv';
BER.h2dBInit = 0;
BER.h2dBInitStep = 0.1;
BER.h2dBMaxStep = 1;
BER.h2dBMinStep = 0.1;
BER.h2dBMax = 10;
Common.NumWorkers = 4;
Common.SaveFileName = 'QPSK-CONV-HARD';

Source.NumBitsPerFrame = 2*3*4*5*8;
Mapper.Type = 'PSK';
Mapper.isTransparent = false;
Channel.isTransparent = false;
Mapper.ModulationOrder = 4;
%  Mapper.DecisionMethod = 'Approximate log-likelihood ratio';
Mapper.DecisionMethod = 'Hard decision';

% End of Params

Common.SaveDirName = 'L1P1';
Encoder.isTransparent = false;
Encoder.Type = 'conv';
BER.h2dBInit = 0;
BER.h2dBInitStep = 0.1;
BER.h2dBMaxStep = 1;
BER.h2dBMinStep = 0.1;
BER.h2dBMax = 10;
Common.NumWorkers = 4;
Common.SaveFileName = 'QAM-16-CONV-HARD';

Source.NumBitsPerFrame = 2*3*4*5*8;
Mapper.Type = 'QAM';
Mapper.isTransparent = false;
Channel.isTransparent = false;
Mapper.ModulationOrder = 16;
%  Mapper.DecisionMethod = 'Approximate log-likelihood ratio';
Mapper.DecisionMethod = 'Hard decision';
% End of Params


%% p1. SOFT [LLR]

Common.SaveDirName = 'L1P1';
Encoder.isTransparent = false;
Encoder.Type = 'conv-soft';
BER.h2dBInit = 0;
BER.h2dBInitStep = 0.1;
BER.h2dBMaxStep = 1;
BER.h2dBMinStep = 0.1;
BER.h2dBMax = 10;

Common.SaveFileName = 'QPSK-CONV-SOFT[LLR]';

Source.NumBitsPerFrame = 2*3*4*5*8;
Mapper.Type = 'PSK';
Mapper.isTransparent = false;
Channel.isTransparent = false;
Mapper.ModulationOrder = 4;
% Mapper.DecisionMethod = 'Approximate log-likelihood ratio';
Common.NumWorkers = 4;

% End of Params
Common.SaveDirName = 'L1P1';
Encoder.isTransparent = false;
Encoder.Type = 'conv-soft';
BER.h2dBInit = 0;
BER.h2dBInitStep = 0.1;
BER.h2dBMaxStep = 1;
BER.h2dBMinStep = 0.1;
BER.h2dBMax = 10;

Common.SaveFileName = 'QAM-16-CONV-SOFT[LLR]';

Source.NumBitsPerFrame = 2*3*4*5*8;
Mapper.Type = 'QAM';
Mapper.isTransparent = false;
Channel.isTransparent = false;
Mapper.ModulationOrder = 16;
% Mapper.DecisionMethod = 'Approximate log-likelihood ratio';
Common.NumWorkers = 4;

% End of Params


%% p1. SOFT [ALLR]

Common.SaveDirName = 'L1P1';
Encoder.isTransparent = false;
Encoder.Type = 'conv-soft';
BER.h2dBInit = 0;
BER.h2dBInitStep = 0.1;
BER.h2dBMaxStep = 1;
BER.h2dBMinStep = 0.1;
BER.h2dBMax = 10;
Common.SaveFileName = 'QPSK-CONV-SOFT[ALLLR]';

Source.NumBitsPerFrame = 2*3*4*5*8;
Mapper.Type = 'PSK';
Mapper.isTransparent = false;
Channel.isTransparent = false;
Mapper.ModulationOrder = 4;
Mapper.DecisionMethod = 'Approximate log-likelihood ratio';
Common.NumWorkers = 4;

% End of Params
Common.SaveDirName = 'L1P1';
Encoder.isTransparent = false;
Encoder.Type = 'conv-soft';
BER.h2dBInit = 0;
BER.h2dBInitStep = 0.1;
BER.h2dBMaxStep = 1;
BER.h2dBMinStep = 0.1;
BER.h2dBMax = 10;
Common.SaveFileName = 'QAM-16-CONV-SOFT[ALLLR]';

Source.NumBitsPerFrame = 2*3*4*5*8;
Mapper.Type = 'QAM';
Mapper.isTransparent = false;
Channel.isTransparent = false;
Mapper.ModulationOrder = 16;
Mapper.DecisionMethod = 'Approximate log-likelihood ratio';
Common.NumWorkers = 4;

% End of Params


%% p3. LDPC [HARD]
%{
Common.SaveFileName = 'QPSK-LDPC-NOinter-Hard';
Common.SaveDirName = 'L1P3';
Common.NumWorkers = 3;


% Mapper.DecisionMethod = 'Approximate log-likelihood ratio';
Mapper.DecisionMethod = 'Hard decision';
Mapper.Type = 'PSK';
Mapper.isTransparent = false;
Channel.isTransparent = false;
Mapper.ModulationOrder = 8;

Encoder.isTransparent = false;
Encoder.rateLDPC = dvbs2ldpc(1/2);
Encoder.Type = 'LDPC';
BER.h2dBInit = 5;
BER.h2dBInitStep = 0.2;
BER.h2dBMaxStep = 1;
BER.h2dBMinStep = 0.1;
BER.h2dBMax = 16;
BER.MinBER = 10^-4;
Source.NumBitsPerFrame = size(Encoder.rateLDPC, 2)/2;

% End of Params

Common.SaveFileName = 'QPSK-LDPC-inter-Hard';
Common.SaveDirName = 'L1P3';
Common.NumWorkers = 3;
Interleaver.isTransparent = false;

% Mapper.DecisionMethod = 'Approximate log-likelihood ratio';
Mapper.DecisionMethod = 'Hard decision';
Mapper.Type = 'PSK';
Mapper.isTransparent = false;
Channel.isTransparent = false;
Mapper.ModulationOrder = 8;

Encoder.isTransparent = false;
Encoder.rateLDPC = dvbs2ldpc(1/2);
Encoder.Type = 'LDPC';
BER.h2dBInit = 5;
BER.h2dBInitStep = 0.2;
BER.h2dBMaxStep = 1;
BER.h2dBMinStep = 0.1;
BER.h2dBMax = 16;
BER.MinBER = 10^-4;
Source.NumBitsPerFrame = size(Encoder.rateLDPC, 2)/2;
%}


%% p3. LDPC [SOFT]
%{
Common.SaveFileName = 'QPSK-LDPC-NOinter-Soft';
Common.SaveDirName = 'L1P3';
Common.NumWorkers = 3;


Mapper.DecisionMethod = 'Log-likelihood ratio';
% Mapper.DecisionMethod = 'Hard decision';
Mapper.Type = 'PSK';
Mapper.isTransparent = false;
Channel.isTransparent = false;
Mapper.ModulationOrder = 4;

Encoder.isTransparent = false;
Encoder.rateLDPC = dvbs2ldpc(1/2);
Encoder.Type = 'LDPC-soft';
BER.h2dBInit = 8;
BER.h2dBInitStep = 0.7;
BER.h2dBMaxStep = 1;
BER.h2dBMinStep = 0.1;
BER.h2dBMax = 16;
BER.MinBER = 10^-5;
% Source.NumBitsPerFrame = 38880;
% Source.NumBitsPerFrame = 1000;
% Source.NumBitsPerFrame = 32400;
Source.NumBitsPerFrame = size(Encoder.rateLDPC, 2)/2;
%}
% End of Params
%{
Common.SaveDirName = 'P3';
Encoder.isTransparent = false;
Encoder.Type = 'LDPC';
BER.h2dBInit = 0;
BER.h2dBInitStep = 0.1;
BER.h2dBMaxStep = 1;
BER.h2dBMinStep = 0.1;
BER.h2dBMax = 10;
Common.SaveFileName = 'QPSK-LDPC-inter';

Source.NumBitsPerFrame = 38880;
Mapper.Type = 'PSK';
Mapper.isTransparent = false;
Channel.isTransparent = false;
Mapper.ModulationOrder = 4;
Mapper.DecisionMethod = 'Approximate log-likelihood ratio';
Common.NumWorkers = 3;

%}
%% p3. LDPC
%{
Common.SaveDirName = 'L1P3_1';
Common.NumWorkers = 3;
Common.SaveFileName = 'QPSK-LDPC-NOinter-ALLR';
Mapper.isTransparent = false;
Channel.isTransparent = false;
Encoder.isTransparent = false;
Encoder.Type = 'LDPC-soft';
Mapper.Type = 'PSK';
Mapper.ModulationOrder = 4;
Mapper.DecisionMethod = 'Approximate log-likelihood ratio';
BER.BERNumRateDigits = 8;
BER.FERNumRateDigits = 5;
BER.BERPrecision = 5;
BER.h2Precision = 3;
BER.h2dBInitStep = 0.1;
BER.h2dBMaxStep = 1;
BER.h2dBMax = -0.5;
BER.h2dBMinStep = 0.1;
BER.h2dBInit = -5;
Source.NumBitsPerFrame = 32400;

% End of Params
Common.SaveFileName = 'QPSK-LDPC-NOinter-LLR';
Common.SaveDirName = 'L1P3_1';
Common.NumWorkers = 3;
Mapper.isTransparent = false;
Channel.isTransparent = false;
Encoder.isTransparent = false;
Encoder.Type = 'LDPC-soft';
Mapper.Type = 'PSK';
Mapper.ModulationOrder = 4;
Mapper.DecisionMethod = 'Log-likelihood ratio';
BER.BERNumRateDigits = 8;
BER.FERNumRateDigits = 5;
BER.BERPrecision = 5;
BER.h2Precision = 3;
BER.h2dBInitStep = 0.1;
BER.h2dBMaxStep = 1;
BER.h2dBMax = -0.5;
BER.h2dBMinStep = 0.1;
BER.h2dBInit = -5;
Source.NumBitsPerFrame = 32400;

% End of Params

Common.SaveFileName = 'QPSK-LDPC-NOinter-HARD';
Common.SaveDirName = 'L1P3_1';
Common.NumWorkers = 4;
Mapper.isTransparent = false;
Channel.isTransparent = false;
Encoder.isTransparent = false;
Encoder.Type = 'LDPC';
Mapper.Type = 'PSK';
Mapper.ModulationOrder = 4;
Mapper.DecisionMethod = 'Hard decision';
BER.BERNumRateDigits = 8;
BER.FERNumRateDigits = 5;
BER.BERPrecision = 5;
BER.h2Precision = 3;
BER.h2dBInitStep = 0.1;
BER.h2dBMax = 12;
BER.h2dBMaxStep = 1;
BER.h2dBMinStep = 0.1;
BER.h2dBInit = -5;
Source.NumBitsPerFrame = 32400;
%}
%% p3. LDPC [InterLeaver]
%{
Interleaver.isTransparent = false;
Common.SaveDirName = 'L1P3_2';
Common.NumWorkers = 4;
Common.SaveFileName = 'QPSK-LDPC-inter-ALLR';
Mapper.isTransparent = false;
Channel.isTransparent = false;
Encoder.isTransparent = false;
Encoder.Type = 'LDPC-soft';
Mapper.Type = 'PSK';
Mapper.ModulationOrder = 4;
Mapper.DecisionMethod = 'Approximate log-likelihood ratio';
BER.BERNumRateDigits = 8;
BER.FERNumRateDigits = 5;
BER.BERPrecision = 5;
BER.h2Precision = 3;
BER.h2dBInitStep = 0.1;
BER.h2dBMaxStep = 1;
BER.h2dBMax = -0.5;
BER.h2dBMinStep = 0.1;
BER.h2dBInit = -5;
Source.NumBitsPerFrame = 32400;
%}