function Params = SetParams(inParams, ParamsNumber, LogLanguage)

	% ������������ ������� ������
		Params = inParams;

	% ����� ����� ��������� Params �������� ������	
		FieldNames = { ...
			'Source', ...
			'Encoder', ...
			'Interleaver', ...
			'Mapper', ...
			'Sig', ...
			'Channel', ...
			'BER', ...
			'Common' ...
		};

	for n = 1:length(FieldNames) % ���� �� ���� ����� Params ��������
			% ������
		% ���� ���� �������� ������ �� ����������, ��� ���� �������
			if ~isfield(Params, FieldNames{n})
				Params.(FieldNames{n}) = [];
			end
		% ������� ��������� �� �������
			Fun = str2func(['SetParams', FieldNames{n}]);
		% ����� �������, ���������������� ��������� ������� ������
			Params.(FieldNames{n}) = Fun(Params.(FieldNames{n}), ...
				ParamsNumber, LogLanguage);
	end

end
function Source = SetParamsSource(inSource, ParamsNumber, ...
	LogLanguage) %#ok<INUSL,DEFNU>

	% ������������ ������� ������
		Source = inSource;
		
	% ���������� ���, ������������ � ����� �����
		if ~isfield(Source, 'NumBitsPerFrame')
			Source.NumBitsPerFrame = 1000;
		else
			% �������� ������������ �������� ��������
			if Source.NumBitsPerFrame < 1
				if strcmp(LogLanguage, 'Russian')
					error('������������ �������� Source.NumBitsPerFrame');
				else
					error('Invalid value Source.NumBitsPerFrame');
				end
			end
		end
end
function Encoder = SetParamsEncoder(inEncoder, ParamsNumber, ...
	LogLanguage) %#ok<INUSD,DEFNU>

	% ������������ ������� ������
		Encoder = inEncoder;

	% ����� �� ��������� ����������� � �������������
		if ~isfield(Encoder, 'isTransparent')
			Encoder.isTransparent = true;
		else
			% �������� ������������ �������� ��������
		end
		
	% ��� �����������
		if ~isfield(Encoder, 'Type')
			Encoder.Type = '';
		else
			if ~(strcmp(Encoder.Type, 'conv') || ...
				 strcmp(Encoder.Type, 'conv-soft')|| ...
				 strcmp(Encoder.Type, 'LDPC-soft')|| ...
				 strcmp(Encoder.Type, 'LDPC')	)
			 
				if strcmp(LogLanguage, 'Russian')
					error('������������ �������� Encoder.Type');
				else
					error('Invalid value Encoder.Type');
				end
			end
		end
		if ~isfield(Encoder, 'rateLDPC')
			Encoder.rateLDPC = dvbs2ldpc(1/2);
		end
		if ~isfield(Encoder, 'TbLen')
			Encoder.TbLen = 34;
		else
			if (Encoder.TbLen < 1)
				if strcmp(LogLanguage, 'Russian')
					error('������������ �������� Encoder.Type');
				else
					error('Invalid value Encoder.Type');
				end
			end
		end;
	% ��������� ���������� ����������� � CalcAndCheckParams():
		% isSoftInput;
end
function Interleaver = SetParamsInterleaver(inInterleaver, ...
	ParamsNumber, LogLanguage) %#ok<INUSD,DEFNU>

	% ������������ ������� ������
		Interleaver = inInterleaver;

	% ����� �� ��������� ����������� � �������������
		if ~isfield(Interleaver, 'isTransparent')
			Interleaver.isTransparent = true;
		else
			if ~isfield(Interleaver, 'RowsReadingSequence')
				Interleaver.RowsReadingSequence = 'none';
			end;
		
			if ~isfield(Interleaver, 'order')
				Interleaver.order = randperm(32400)';
			end
		end;
		
		
end
function Mapper = SetParamsMapper(inMapper, ParamsNumber, ...
	LogLanguage) %#ok<INUSL,DEFNU>

	% ������������ ������� ������
		Mapper = inMapper;

	% ����� �� ��������� ��������� � �����������
		if ~isfield(Mapper, 'isTransparent')
			Mapper.isTransparent = true;
		else
			% �������� ������������ �������� ��������
		end

	% ��� ����������� ���������: QAM | PSK
		if ~isfield(Mapper, 'Type')
			Mapper.Type = 'QAM';
		else
			if ~(strcmp(Mapper.Type, 'QAM') || ...
					strcmp(Mapper.Type, 'PSK')|| ...
					strcmp(Mapper.Type, 'APSK'))
				if strcmp(LogLanguage, 'Russian')
					error('������������ �������� Mapper.Type');
				else
					error('Invalid value Mapper.Type');
				end
			end
		end
	
	% ������ ����������� ���������
		if ~isfield(Mapper, 'ModulationOrder')
			Mapper.ModulationOrder = 4;
		else
			% �������� ������������ �������� ��������
		end
		
	% ������� ����������� ���������
		if ~isfield(Mapper, 'PhaseOffset')
			Mapper.PhaseOffset = 0;
		else
			% �������� ������������ �������� ��������
		end
		
	% ��� ����������� ��� �� ����� ����������� ���������: Binary | Gray
		if ~isfield(Mapper, 'SymbolMapping')
			Mapper.SymbolMapping = 'Gray';
		else
			if ~(strcmp(Mapper.SymbolMapping, 'Binary') || ...
					strcmp(Mapper.SymbolMapping, 'Gray'))
				if strcmp(LogLanguage, 'Russian')
					error('������������ �������� Mapper.SymbolMapping');
				else
					error('Invalid value Mapper.SymbolMapping');
				end
			end
		end

	% ������� �������� ������� � ������������� ��������:  Hard decision |
	% Log-likelihood ratio | Approximate log-likelihood ratio
		if ~isfield(Mapper, 'DecisionMethod')
			Mapper.DecisionMethod = 'Approximate log-likelihood ratio';
		else
			if ~(strcmp(Mapper.DecisionMethod, 'Hard decision') || ...
					strcmp(Mapper.DecisionMethod, ...
					'Log-likelihood ratio') || ...
					strcmp(Mapper.DecisionMethod, ...
					'Approximate log-likelihood ratio'))
				if strcmp(LogLanguage, 'Russian')
					error('������������ �������� Mapper.DecisionMethod');
				else
					error('Invalid value Mapper.DecisionMethod');
				end
			end
		end
end
function Sig = SetParamsSig(inSig, ParamsNumber, ...
	LogLanguage) %#ok<INUSD,DEFNU>

	% ������������ ������� ������
		Sig = inSig;

	% ����� �� ��������� ������������ ������� � ��������� ��� ���������
	% ��� �����
		if ~isfield(Sig, 'isTransparent')
			Sig.isTransparent = true;
		else
			% �������� ������������ �������� ��������
		end
end
function Channel = SetParamsChannel(inChannel, ParamsNumber, ...
	LogLanguage) %#ok<INUSD,DEFNU>

	% ������������ ������� ������
		Channel = inChannel;

	% ����� �� ���������� ������ ����� �����
		if ~isfield(Channel, 'isTransparent')
			Channel.isTransparent = true;
		else
			% �������� ������������ �������� ��������
		end
		
	% ��� ������: AWGN | Fading
		if ~isfield(Channel, 'Type')
			Channel.Type = 'AWGN';
		else
			% �������� ������������ �������� ��������
		end
		
	% ��� ������������� ������: '' | 'EPA' | 'EVA' | 'ETU'
	% ����������� ������ ��� Channel.Type = 'Fading'.
		if ~isfield(Channel, 'FadingType')
			Channel.FadingType = '';
		else
			% �������� ������������ �������� ��������
		end
end
function BER = SetParamsBER(inBER, ParamsNumber, ...
	LogLanguage) %#ok<INUSD,DEFNU>

	% ������ ������� ����� ���������������, ����
	%   ) ��������� ��������� ���
	%   ) ������� ����������� ���������� � ���������� ���������� ������
	%	 ������ ���� �����, ��� MinNumTrFrames
	%
	% �������� ������ ������ ������������������ ���������������, ����
	%   ) ��������� ��������� ���
	%   ) ��������� ����������� ������������� �������� h2
	%
	% ��������� ���������, ���� �������� ��� ������, ��� MaxNumTrBits, ���
	%   �������� ������ ������, ��� MaxNumTrFrames.
	%
	% ������� ����������� ������ ����������, ���� ������ �����������
	%   ������� ������ ������ ���� �����, ��� MinBER, � ������ �����������
	%   �������� ������ ������ ���� �����, ��� MinFER.
	%
	% ���������� ��������� �����������, ���� ���������� ������� ������
	%   ������ ���� �����, ��� MinNumErBits, � ���������� �������� ������
	%   ������ ���� �����, ��� MinNumErFrames.
	%
	% �������������� ������ ����� ������ ������������������ ������ �� ���
	%   ���, ���� ��� ���� �������� ����� ������ ������������������ ��
	%   ����� �����, ���
	%   ) ��������� ������������ ������� ������ ����� ��������� �������
	%	 ������ ���� �����, ��� MaxBERRate, ���
	%   ) ������� h2 ����� ����� ������� ������ ���� ����� h2dBMinStep.
	
	% ������������ ������� ������
		BER = inBER;

	% ���������� ����������� ������ ����� ������� ��� �������� � ������ �
	% ��� ��������, ��������� � h2
		if ~isfield(BER, 'h2Precision')
			BER.h2Precision = 2;
		else
			% �������� ������������ �������� ��������
		end

	% ���������� ������ ����� ������� ��� �������� BER, ����������� � ����	
		if ~isfield(BER, 'BERPrecision')
			BER.BERPrecision = 8;
		else
			% �������� ������������ �������� ��������
		end
		
	% ���������� ��������, ������������ ��� ����������� ����� ���������� �
	% ����� ��������� ��� � ����
		if ~isfield(BER, 'BERNumRateDigits')
			BER.BERNumRateDigits = 10;
		else
			% �������� ������������ �������� ��������
		end
		
	% ���������� ��������, ������������ ��� ����������� ����� ���������� �
	% ����� ��������� ������ � ����
		if ~isfield(BER, 'FERNumRateDigits')
			BER.FERNumRateDigits = 7;
		else
			% �������� ������������ �������� ��������
		end

	% ����������� ���������� ������������ ��� ������ ����� ������
	% ������������������ ������ (��� ����������� ����� ���������� ���
	% ����������� ������������� � �������� ��������������)
		if ~isfield(BER, 'MinNumTrFrames')
			BER.MinNumTrFrames = 100;
		else
			% �������� ������������ �������� ��������
		end

	% �������� h2 (��) ������ ����� ��� ������� ������������������
		if ~isfield(BER, 'h2dBInit')
			BER.h2dBInit = 8.4;
		else
			% �������� ������������ �������� ��������
		end

	% ��������� �������� ���� (��) ��� �������� � ����� ������ ��� �������
	% ������������������
		if ~isfield(BER, 'h2dBInitStep')
			BER.h2dBInitStep = 0.4;
		else
			% �������� ������������ �������� ��������
		end

	% ������������ �������� ���� (��) ��� �������� � ����� ������ ���
	% ������� ������ ������������������
		if ~isfield(BER, 'h2dBMaxStep')
			BER.h2dBMaxStep = 1.6;
		else
			% �������� ������������ �������� ��������
		end

	% ����������� �������� ���� (��)
		if ~isfield(BER, 'h2dBMinStep')
			BER.h2dBMinStep = 0.1;
		else
			% �������� ������������ �������� ��������
		end

	% ������������ �������� ���������������� ��������� ������/��� (����
	% ������ ������������������ ������ �� ��������� �� ��������� BER ������
	% ����������, �� ��� ����������� �������� �������� �����������
	% ����������)
		if ~isfield(BER, 'h2dBMax')
			BER.h2dBMax = 25;
		else
			% �������� ������������ �������� ��������
		end

	% ��������� ����������� �������� BER, �� ���������� �������� ����������
	% ����� ����������� (����, �������, ����������� �� ���������
	% (BER.MaxNumTrBits) ��� ���� ����������� �� �������� ������)
		if ~isfield(BER, 'MinBER')
			BER.MinBER = 10^-4;
		else
			% �������� ������������ �������� ��������
		end

	% ����������� ���������� ��������� ��� � ������ �����
		if ~isfield(BER, 'MinNumErBits')
			BER.MinNumErBits = 5*10^2;
		else
			% �������� ������������ �������� ��������
		end

	% ��������� ����������� �������� FER, �� ���������� �������� ����������
	% ����� �����������
		if ~isfield(BER, 'MinFER')
			BER.MinFER = 1; % �.�. ����������� �� ��� �������� ���!
		else
			% �������� ������������ �������� ��������
		end

	% ����������� ���������� ��������� ������ � ������ �����
		if ~isfield(BER, 'MinNumErFrames')
			BER.MinNumErFrames = 10^2;
		else
			% �������� ������������ �������� ��������
		end

	% ������������ ���������� ���������� ���
		if ~isfield(BER, 'MaxNumTrBits')
			BER.MaxNumTrBits = 10^8;
		else
			% �������� ������������ �������� ��������
		end

	% ������������ ���������� ���������� ������
		if ~isfield(BER, 'MaxNumTrFrames')
			BER.MaxNumTrFrames = inf; % �.�. ����������� �� ��� ��������
				% ���!
		else
			% �������� ������������ �������� ��������
		end

	% ������������ ��������� ������������ ������� ������ � ��������
	% ������, ������ �������� ���������� ���������� ���� h2dB. �������, ���
	% ���� ��� ���������� "����������" ������ ������������������, ��
	% �������� ����� �������� ����������� ������ ��� ������, ��� ������
	% �������� h2 (��). ��� ���� ������ ����� ����������� ������
	% ��������� �������� ����������� ������. �������, ���� ���
	% ���������� ���� ��������� ������������ ������ ���� �������, ��
	% ��� ��������� ���� ��� ����� ��� ������ �, ����� ������
	% ���������� ������ ������������������ (����, �� ���� � ����������� ��
	% ���������!), ���� ��������� ��� �� ��� h2 (��).
		if ~isfield(BER, 'MaxBERRate')
			BER.MaxBERRate = 5;
		else
			% �������� ������������ �������� ��������
		end

	% ����������� ��������� ������������ ������� ������ � ��������
	% ������, ������ �������� ���������� ���������� ���� h2dB. �������� �
	% �������� ��������, ����� ������ �������� �������� �� �������
	% ����� ������ ������������������. � ����� �������� ����� �����
	% ����������� ��� �� ��� h2 (��), �� ����� �������� ���������� ��
	% ��������� ����������� ������.
		if ~isfield(BER, 'MinBERRate')
			BER.MinBERRate = 2;
		else
			% �������� ������������ �������� ��������
		end
end
function Common = SetParamsCommon(inCommon, ParamsNumber, ...
	LogLanguage) %#ok<INUSD,DEFNU>

	% ������������ ������� ������
		Common = inCommon;

	% ��� ����� ��� ���������� �����������
		if ~isfield(Common, 'SaveFileName')
			Common.SaveFileName = sprintf('Results%02d', ParamsNumber);
		else
			% �������� ������������ �������� ��������
		end

	% ��� ���������� ��� ���������� �����������
		if ~isfield(Common, 'SaveDirName')
			Common.SaveDirName = 'Results';
		else
			% �������� ������������ �������� ��������
		end

	% ���������� ������, ������������ � �������������� �� ���� ��������.
	% ��� ������������� Common.NumWorkers > 1 �������, �����
	% NumOneIterFrames �������� �� Common.NumWorkers ��� �������.
		if ~isfield(Common, 'NumOneIterFrames')
			Common.NumOneIterFrames = 100;
		else
			% �������� ������������ �������� ��������
		end

	% ���������� ����, ������������ ��� ������������ ����������
		if ~isfield(Common, 'NumWorkers')
			Common.NumWorkers = 1;
		else
			% �������� ������������ �������� ��������
		end

	% ����� �� ������ ���������� ���� command window ��� ������ �����
	% ������ ����������� NumOneIterFrames ������
		if ~isfield(Common, 'isRealTimeLogCWin')
			Common.isRealTimeLogCWin = 1;
		else
			% �������� ������������ �������� ��������
		end

	% ����� �� ������ ���������� ���� � ����� ��� ������ �����
	% ������ ����������� NumOneIterFrames ������
		if ~isfield(Common, 'isRealTimeLogFile')
			Common.isRealTimeLogFile = 0;
		else
			% �������� ������������ �������� ��������
		end
end