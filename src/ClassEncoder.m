classdef ClassEncoder < handle
	
    properties (SetAccess = private) % ���������� �� ����������
        % ����� �� ��������� ����������� � �������������
            isTransparent;
			Type;
			TbLen;
        % ���������� ���������� ������ ������ ���������� ��� ������������
            LogLanguage;
    end
    properties (SetAccess = private) % ����������� ����������
			trellis;
			encLDPC;
			decLDPC;
    end
    methods
        function obj = ClassEncoder(Params, LogLanguage) % �����������
            % ������� ���� Params, ����������� ��� �������������
                Encoder  = Params.Encoder;
            % ������������� �������� ���������� �� ����������
                obj.isTransparent = Encoder.isTransparent;
				obj.Type = Encoder.Type;
            % ���������� LogLanguage
                obj.LogLanguage = LogLanguage;
			% Init of polynom for convolution encoder and viterbi decoder
				obj.trellis = poly2trellis(7,[171 133]);
				obj.TbLen = Encoder.TbLen;
				obj.encLDPC = comm.LDPCEncoder(Encoder.rateLDPC);
				obj.decLDPC = comm.LDPCDecoder(Encoder.rateLDPC);
        end
        function OutData = StepTx(obj, InData)
			if obj.isTransparent
                OutData = InData;
                return
			end;
			if (strcmp(obj.Type, 'conv') || strcmp(obj.Type, 'conv-soft') )
				OutData=convenc(InData,obj.trellis);
			elseif strcmp(obj.Type, 'LDPC')
				OutData = obj.encLDPC(InData); 
			else
				OutData = InData;
			end;
			
        end
        function OutData = StepRx(obj, InData)
			if obj.isTransparent
                OutData = InData;
                return
			end;
            
			if strcmp(obj.Type, 'conv')
				OutData = vitdec(InData,obj.trellis, 35,'trunc','hard');
			elseif strcmp(obj.Type, 'conv-soft')
				OutData = vitdec(InData,obj.trellis, 35,'trunc','unquant');
			elseif strcmp(obj.Type, 'LDPC')
				OutData = obj.decLDPC(-2*InData+1); 
			else
				OutData = InData;
			end;
        end
    end
end