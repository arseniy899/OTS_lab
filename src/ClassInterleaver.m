classdef ClassInterleaver < handle
    properties (SetAccess = private) % ���������� �� ����������
        % ����� �� ��������� ����������� � �������������
            isTransparent;
        % ���������� ���������� ������ ������ ���������� ��� ������������
            LogLanguage;
    end
    properties (SetAccess = private) % ����������� ����������
		order;
    end
    methods
        function obj = ClassInterleaver(Params, LogLanguage) % �����������
            % ������� ���� Params, ����������� ��� �������������
                Interleaver  = Params.Interleaver;
            % ������������� �������� ���������� �� ����������
                obj.isTransparent = Interleaver.isTransparent;
            % ���������� LogLanguage
                obj.LogLanguage = LogLanguage;
				obj.order  = Interleaver.order;
        end
        function OutData = StepTx(obj, InData)
            if obj.isTransparent
                OutData = InData;
                return
            end
            
            % ����� ������ ���� ��������� �����������
            OutData = intrlv(InData,obj.order);
        end
        function OutData = StepRx(obj, InData)
            if obj.isTransparent
                OutData = InData;
                return
            end
            
            % ����� ������ ���� ��������� �������������
            OutData = deintrlv(InData,obj.order);
        end
    end
end