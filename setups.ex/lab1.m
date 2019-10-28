%% p1. HARD
Common.SaveDirName = 'L1P1';
Encoder.isTransparent = false;
Encoder.Type = 'conv';
BER.h2dBInit = 0;
BER.h2dBInitStep = 0.1;
BER.h2dBMaxStep = 1;
BER.h2dBMinStep = 0.1;
BER.h2dBMax = 10;

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

Common.SaveFileName = 'QAM-16-CONV-HARD';

Source.NumBitsPerFrame = 2*3*4*5*8;
Mapper.Type = 'QAM';
Mapper.isTransparent = false;
Channel.isTransparent = false;
Mapper.ModulationOrder = 16;
%  Mapper.DecisionMethod = 'Approximate log-likelihood ratio';
Mapper.DecisionMethod = 'Hard decision';
% End of Params


%% p1. SOFT [люб]
%{
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
Common.NumWorkers = 2;

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
Common.NumWorkers = 2;

% End of Params
%}

%% p1. SOFT [ло]
%{
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
Common.NumWorkers = 2;

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
Common.NumWorkers = 2;

% End of Params
%}

%% p3. LDPC
%{
Common.SaveDirName = 'L1P3';
Encoder.isTransparent = false;
Mapper.DecisionMethod = 'Hard decision';
Encoder.Type = 'LDPC';
BER.h2dBInit = 0;
BER.h2dBInitStep = 0.5;
BER.h2dBMaxStep = 1;
BER.h2dBMinStep = 0.1;
BER.h2dBMax = 8;
Encoder.rateLDPC = dvbs2ldpc(1/2);
Source.NumBitsPerFrame = size(Encoder.rateLDPC, 2)/2;
Common.SaveFileName = 'QPSK-LDPC-NOinter';

Mapper.Type = 'PSK';
Mapper.isTransparent = false;
Channel.isTransparent = false;
Mapper.ModulationOrder = 8;
% Mapper.DecisionMethod = 'Approximate log-likelihood ratio';
Common.NumWorkers = 3;
%}
% End of Params
%{
Common.SaveDirName = 'L1P3';
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

