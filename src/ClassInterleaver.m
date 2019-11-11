classdef ClassInterleaver < handle
	properties (SetAccess = private) % ���������� �� ����������
		% ����� �� ��������� ����������� � �������������
			isTransparent;
		% ���������� ���������� ������ ������ ���������� ��� ������������
			LogLanguage;
	end
	properties (SetAccess = private) % ����������� ����������
		% ��������� ������ ������������� �������� ������� ������������
		RowsReadingSequence;
		% ������ ����������� ���������
		ModulationOrder;
		 % ������ ������������ ������
		PermPattern;
	end
	methods
		function obj = ClassInterleaver(Params, LogLanguage) % �����������
			% ������� ���� Params, ����������� ��� �������������
				Interleaver  = Params.Interleaver;
				Mapper = Params.Mapper;
			% ������������� �������� ���������� �� ����������
				obj.isTransparent = Interleaver.isTransparent;
			% ���������� LogLanguage
				obj.LogLanguage = LogLanguage;
				if ~obj.isTransparent
					obj.RowsReadingSequence = Interleaver.RowsReadingSequence;
					obj.ModulationOrder = Mapper.ModulationOrder;
					if strcmp(obj.RowsReadingSequence, 'none')
						obj.PermPattern = [];
					else
						% ��������� ���������� �������� ������� ������������
							log2M = round(log2(obj.ModulationOrder));
						% ��������� ����� ������������� ��������
							if strcmp(obj.RowsReadingSequence, 'seq')
								RRS = 0:(log2M-1);
							else
								RRS = obj.RowsReadingSequence - 48;
							end
						% ��������� ����� �������������� ���
							FECFrameLen = 64800;
							%FECFrameLen = 32400;
							if isequal(obj.ModulationOrder, 128)
								FECFrameLen = FECFrameLen + 6;
							end
						% ���������� ������ ������������
							obj.PermPattern = 1:FECFrameLen;
							obj.PermPattern = reshape(obj.PermPattern, [], ...
								log2M);
							obj.PermPattern = obj.PermPattern(:, RRS+1);
							obj.PermPattern = reshape(obj.PermPattern.', ...
								[], 1);
					end;
				end;
		end
		function OutData = StepTx(obj, InData)
			if obj.isTransparent || isempty(obj.PermPattern)
				OutData = InData;
			else
				OutData = InData(obj.PermPattern);
			end
			if isequal(obj.ModulationOrder, 128)
				OutData = [OutData; ones(84, 1)];
			end
		end
		function OutData = StepRx(obj, InData)
			if isequal(obj.ModulationOrder, 128)
				InData = InData(1:end-84);
			end
			if obj.isTransparent || isempty(obj.PermPattern)
				OutData = InData;
				return
			end
			OutData = zeros(size(InData));
			OutData(obj.PermPattern) = InData;
		end
	end
end