function Params = CalcAndCheckParams(inParams, LogLanguage)
%
% � ���� ������� ����� ��������� ������������ ��������� ����������
% ���������� �/��� ��������� ������ ���������� ������ ������, ��������� ��
% ���������� ������ �������, ����� ��� ���� ��������, ��� �������
% CalcAndCheckParams ���������� �� �������� ��������, �.�. �� ������
% �������������.

% ������������ ������� ������
    Params = inParams;
    
% ���� � ������ ��������� �������������, �� � ������������ �����
% ������������� ���������� ����� ��������� ������ �������, ����� ��
% ������� ��������� ��������� ���������� � ���������� ����������
    if Params.Encoder.isTransparent
        Params.Mapper.DecisionMethod = 'Hard decision';
    end
    
% �������� ����, ��� � ��������� ��������� ����� ���, ��������� �� log2(M)
    if Params.Encoder.isTransparent
        % ��� �������, ����� ������������� ����������� ��������� �
        % ����������� � ������������ � �������� �������������� ��� �
        % ������ Mapper
        if mod(Params.Source.NumBitsPerFrame, ...
                log2(Params.Mapper.ModulationOrder)) > 0
            if strcmp(LogLanguage, 'Russian')
                error(['� ��������� ��������� ����� ��� �� ������� ', ...
                    'log2(M).']);
            else
                error(['The number of bits at the input of the ', ...
                    'mapper is not multiple of log2(M).']);
            end
        end
    end
    