classdef ClassChannel < handle
	properties (SetAccess = private) % ���������� �� ����������
		% ����� �� ���������� ������ ����� �����
			isTransparent;
		% ���������� ���������� ������ ������ ���������� ��� ������������
			LogLanguage;
			NumberOfErrorBitsInFrame;
			PercentOfErrorBitsInFrame;
			FreqShift;
	end
	properties (SetAccess = private) % ����������� ����������
		% �������� ������� �������� �������������� �������
			Ps;
		% �������� ������� �������� �������������� ����
			Pb;
		% �������� ������� �������� ��������������� ����
			Pbd;
	end
	methods
		function obj = ClassChannel(Params, Objs, LogLanguage)
		% �����������
			% ������� ���� Params, ����������� ��� �������������
				Channel = Params.Channel;
			% ������������� �������� ���������� �� ����������
				obj.isTransparent = Channel.isTransparent;
			% ���������� LogLanguage
				obj.LogLanguage = LogLanguage;

			% ��������� ������� �������� �������������� �������
				Const = Objs.Mapper.Constellation;
				obj.Ps = mean((abs(Const)).^2);

			% ��������� ������� �������� �������������� ����
				obj.Pb = obj.Ps / Objs.Mapper.log2M;

			% ��������� ������� �������� ��������������� ���� (�������,
			% ������������ �� �������������� ���, ����������� ������, ���
			% ��� ������������ ����������� ����)
				obj.Pbd = obj.Pb;
				% ����� � ���� ����� ���������� ����� �����������, �� �����
				% ������ ����� ����
				% obj.Pbd = obj.Pb / Objs.Encoder.Rate;
				
			obj.PercentOfErrorBitsInFrame = 1 - Channel.PercentOfErrorBitsInFrame;
			obj.NumberOfErrorBitsInFrame = Channel.NumberOfErrorBitsInFrame;
			
			obj.FreqShift = Channel.FreqShift;
		end
		function [OutData, InstChannelParams] = Step(obj, InData, h2dB)
			if obj.isTransparent
				OutData = InData;
				InstChannelParams.Variance = 1;
				return
			end
			%{
			if (obj.NumberOfErrorBitsInFrame ~= 0)
				InData = [InData(obj.NumberOfErrorBitsInFrame:end);...
					InData(1:obj.NumberOfErrorBitsInFrame)];
			end;
			%}	
			% ���������� ����
				Sigma = sqrt(obj.Pbd * 10^(-h2dB/10) / 2);
				InstChannelParams.Variance = 2*Sigma^2;
				Noise = randn(length(InData), 2) * [1; 1i] * Sigma;

			% ������� ��� � �������
				OutData = InData + Noise;
			
			% ������� �������� �� �������
			
			if (obj.PercentOfErrorBitsInFrame ~= 0)
				datLen = length(OutData);
% 				r = randi(length(OutData)-1,1,obj.NumberOfRandomTimeShifts);
				NumberOfRandomTimeShifts = int32(obj.PercentOfErrorBitsInFrame ...
					* datLen); 
				delInd = int32(datLen-1):-1:NumberOfRandomTimeShifts;
				for k = delInd
					OutData(k)    = [];
				end;
				OutData = [OutData; zeros(length(delInd), 1)];
			end;
			
			% ������� �������� �� �������
			if (obj.FreqShift ~= 0)
				OutData = OutData .';
				N=length(OutData);
				OutData = OutData .* exp(-1i*2*pi/N*(0:N-1)*obj.FreqShift);
				OutData = OutData .';
			end
			
		end
	end
end