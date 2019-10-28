classdef ClassSig < handle
    properties (SetAccess = private) % ���������� �� ����������
        % ����� �� ��������� ������������ ������� � ��������� ��� ���������
        % ��� �����
            isTransparent;
        % ���������� ���������� ������ ������ ���������� ��� ������������
            LogLanguage;
    end
    properties (SetAccess = private) % ����������� ����������
    end
    methods
        function obj = ClassSig(Params, LogLanguage) % �����������
            % ������� ���� Params, ����������� ��� �������������
                Sig  = Params.Sig;
            % ������������� �������� ���������� �� ����������
                obj.isTransparent = Sig.isTransparent;
            % ���������� LogLanguage
                obj.LogLanguage = LogLanguage;
        end
        function OutData = StepTx(obj, InData)
            if obj.isTransparent
                OutData = InData;
                return
            end
            
            % ����� ������ ���� ��������� ������������ �������
            OutData = InData;
        end
        function OutData = StepRx(obj, InData)
            if obj.isTransparent
                OutData = InData;
                return
            end
            
            % ����� ������ ���� ���������, �������� �������� ������������
            % �������
            OutData = InData;
        end
    end
end