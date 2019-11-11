classdef ClassRRCFilter < handle
	properties (SetAccess = private) % ���������� �� ����������
		% ����� �� ��������� ��������� � �����������
			isTransparent;
		% ���������� ���������� ������ ������ ���������� ��� ������������
			LogLanguage;
			
			sps;
			span;
			rolloff;
	end
	properties (SetAccess = private) % ����������� ����������
		filter;
	end
	methods
		function obj = ClassRRCFilter(Params, LogLanguage) % �����������
			% ������� ���� Params, ����������� ��� �������������
				RRCFilter  = Params.RRCFilter;
			% ������������� �������� ���������� �� ����������
				obj.isTransparent = RRCFilter.isTransparent;
				obj.sps = RRCFilter.sps;
				obj.rolloff = RRCFilter.rolloff;
				obj.span = RRCFilter.span;
			% ���������� LogLanguage
				obj.LogLanguage = LogLanguage;
				obj.filter = rcosdesign(obj.rolloff, obj.span, obj.sps);
		end
		function OutData = StepTx(obj, InData)
			if obj.isTransparent
				OutData = InData;
				return
			end
			
			OutData = upfirdn(InData, obj.filter, obj.sps);
		end
		function OutData = StepRx(obj, InData)
			if obj.isTransparent
				OutData = InData;
				return
			end
			OutData = upfirdn(InData,  obj.filter, 1,  obj.sps);
			OutData = OutData(obj.span+1:end- obj.span);
		end
	end
end