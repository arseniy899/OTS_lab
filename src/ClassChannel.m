classdef ClassChannel < handle
	properties (SetAccess = private) % Переменные из параметров
		% Нужно ли пропускать сигнал через канал
			isTransparent;
		% Переменная управления языком вывода информации для пользователя
			LogLanguage;
			NumberOfErrorBitsInFrame;
			PercentOfErrorBitsInFrame;
			FreqShift;
	end
	properties (SetAccess = private) % Вычисляемые переменные
		% Значение средней мощности модуляционного символа
			Ps;
		% Значение средней мощности модуляционного бита
			Pb;
		% Значение средней мощности информационного бита
			Pbd;
	end
	methods
		function obj = ClassChannel(Params, Objs, LogLanguage)
		% Конструктор
			% Выделим поля Params, необходимые для инициализации
				Channel = Params.Channel;
			% Инициализация значений переменных из параметров
				obj.isTransparent = Channel.isTransparent;
			% Переменная LogLanguage
				obj.LogLanguage = LogLanguage;

			% Определим среднюю мощность модуляционного символа
				Const = Objs.Mapper.Constellation;
				obj.Ps = mean((abs(Const)).^2);

			% Определим среднюю мощность модуляционного бита
				obj.Pb = obj.Ps / Objs.Mapper.log2M;

			% Определим среднюю мощность информационного бита (энергия,
			% приходящаяся на информационный бит, оказывается больше, так
			% как используются проверочные биты)
				obj.Pbd = obj.Pb;
				% Когда и если будет реализован класс кодирования, то здесь
				% должно будет быть
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
			% Сформируем АБГШ
				Sigma = sqrt(obj.Pbd * 10^(-h2dB/10) / 2);
				InstChannelParams.Variance = 2*Sigma^2;
				Noise = randn(length(InData), 2) * [1; 1i] * Sigma;

			% Добавим его к сигналу
				OutData = InData + Noise;
			
			% Добавим смещение по времени
			
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
			
			% Добавим смещение по частоте
			if (obj.FreqShift ~= 0)
				OutData = OutData .';
				N=length(OutData);
				OutData = OutData .* exp(-1i*2*pi/N*(0:N-1)*obj.FreqShift);
				OutData = OutData .';
			end
			
		end
	end
end