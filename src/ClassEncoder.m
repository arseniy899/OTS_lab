classdef ClassEncoder < handle
	
    properties (SetAccess = private) % Переменные из параметров
        % Нужно ли выполнять кодирование и декодирование
            isTransparent;
			Type;
			TbLen;
        % Переменная управления языком вывода информации для пользователя
            LogLanguage;
    end
    properties (SetAccess = private) % Вычисляемые переменные
			trellis;
			encLDPC;
			decLDPC;
    end
    methods
        function obj = ClassEncoder(Params, LogLanguage) % Конструктор
            % Выделим поля Params, необходимые для инициализации
                Encoder  = Params.Encoder;
				
            % Инициализация значений переменных из параметров
                obj.isTransparent = Encoder.isTransparent;
				obj.Type = Encoder.Type;
            % Переменная LogLanguage
                obj.LogLanguage = LogLanguage;
			% Init of polynom for convolution encoder and viterbi decoder
				obj.trellis = poly2trellis(7,[171 133]);
				obj.TbLen = Encoder.TbLen;
				if strcmp(obj.Type, 'LDPC') || strcmp(obj.Type, 'LDPC-soft')
					obj.encLDPC = comm.LDPCEncoder('ParityCheckMatrix',Encoder.rateLDPC);
% 					if(strcmp(obj.Type, 'LDPC-soft'))
% 						obj.decLDPC = comm.LDPCDecoder(Encoder.rateLDPC,...
% 							'DecisionMethod', 'Soft decision', 'ParityCheckMatrix',Encoder.rateLDPC);
% 					else
						obj.decLDPC = comm.LDPCDecoder('ParityCheckMatrix',Encoder.rateLDPC);
% 					end;
				end;
        end
        function OutData = StepTx(obj, InData)
			if obj.isTransparent
                OutData = InData;
                return
			end;
			if (strcmp(obj.Type, 'conv') || strcmp(obj.Type, 'conv-soft') )
				OutData=convenc(InData,obj.trellis);
			elseif strcmp(obj.Type, 'LDPC') || strcmp(obj.Type, 'LDPC-soft')
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
% 				OutData = obj.decLDPC(InData);
				InData=1-2*InData; 
				OutData = obj.decLDPC(InData); 
% 				size(OutData )
% 				OutData = logical(OutData);
			elseif strcmp(obj.Type, 'LDPC-soft')
% 				InData=1-2*InData; 
				OutData = obj.decLDPC(InData);
% 				OutData=1-2.*OutData; 
% 				OutData = obj.decLDPC(-2*InData+1); 
% 				size(OutData )
% 				OutData(OutData > 0) = 0;
% 				OutData(OutData < 0) = 1;
				OutData = logical(OutData);
			else
				OutData = InData;
			end;
        end
    end
end