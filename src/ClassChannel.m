classdef ClassChannel < handle
	properties (SetAccess = private) % ���������� �� ����������
		% ����� �� ���������� ������ ����� �����
			isTransparent;
		% ���������� ���������� ������ ������ ���������� ��� ������������
			LogLanguage;
			
			NumberOfRandomTimeShifts;
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
				
			obj.NumberOfRandomTimeShifts = Channel.NumberOfRandomTimeShifts;
			obj.FreqShift = Channel.FreqShift;
		end
		function [OutData, InstChannelParams] = Step(obj, InData, h2dB)
			if obj.isTransparent
				OutData = InData;
				InstChannelParams.Variance = 1;
				return
			end

			% ���������� ����
				Sigma = sqrt(obj.Pbd * 10^(-h2dB/10) / 2);
				InstChannelParams.Variance = 2*Sigma^2;
				Noise = randn(length(InData), 2) * [1; 1i] * Sigma;

			% ������� ��� � �������
				OutData = InData + Noise;
			
			% ������� �������� �� �������
			
			if (obj.NumberOfRandomTimeShifts ~= 0)
				r = randi(length(OutData)-1,1,obj.NumberOfRandomTimeShifts);
				for k = r
					OutData(k)    = [];
% 					OutData(end+1)    = 0;
				end;
				OutData = [OutData; zeros(obj.NumberOfRandomTimeShifts, 1)];
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