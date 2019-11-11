classdef ClassRRCFilter < handle
	properties (SetAccess = private) % Переменные из параметров
		% Нужно ли выполнять модуляцию и демодуляцию
			isTransparent;
		% Переменная управления языком вывода информации для пользователя
			LogLanguage;
			
			sps;
			span;
			rolloff;
	end
	properties (SetAccess = private) % Вычисляемые переменные
		filter;
	end
	methods
		function obj = ClassRRCFilter(Params, LogLanguage) % Конструктор
			% Выделим поля Params, необходимые для инициализации
				RRCFilter  = Params.RRCFilter;
			% Инициализация значений переменных из параметров
				obj.isTransparent = RRCFilter.isTransparent;
				obj.sps = RRCFilter.sps;
				obj.rolloff = RRCFilter.rolloff;
				obj.span = RRCFilter.span;
			% Переменная LogLanguage
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