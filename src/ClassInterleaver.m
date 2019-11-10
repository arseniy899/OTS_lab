classdef ClassInterleaver < handle
	properties (SetAccess = private) % Переменные из параметров
		% Нужно ли выполнять перемежение и деперемежение
			isTransparent;
		% Переменная управления языком вывода информации для пользователя
			LogLanguage;
	end
	properties (SetAccess = private) % Вычисляемые переменные
		% Строковый шаблон перемешивания столбцов матрицы перемежителя
		RowsReadingSequence;
		% Размер сигнального созвездия
		ModulationOrder;
		 % Шаблон перемешанных данных
		PermPattern;
	end
	methods
		function obj = ClassInterleaver(Params, LogLanguage) % Конструктор
			% Выделим поля Params, необходимые для инициализации
				Interleaver  = Params.Interleaver;
				Mapper = Params.Mapper;
			% Инициализация значений переменных из параметров
				obj.isTransparent = Interleaver.isTransparent;
			% Переменная LogLanguage
				obj.LogLanguage = LogLanguage;
				if ~obj.isTransparent
					obj.RowsReadingSequence = Interleaver.RowsReadingSequence;
					obj.ModulationOrder = Mapper.ModulationOrder;
					if strcmp(obj.RowsReadingSequence, 'none')
						obj.PermPattern = [];
					else
						% Определим количество столбцов матрицы перемежителя
							log2M = round(log2(obj.ModulationOrder));
						% Определим шалон перемешивания столбцов
							if strcmp(obj.RowsReadingSequence, 'seq')
								RRS = 0:(log2M-1);
							else
								RRS = obj.RowsReadingSequence - 48;
							end
						% Определим число перемешиваемых бит
							FECFrameLen = 64800;
							%FECFrameLen = 32400;
							if isequal(obj.ModulationOrder, 128)
								FECFrameLen = FECFrameLen + 6;
							end
						% Рассчитаем шаблон перемежителя
							obj.PermPattern = 1:FECFrameLen;
							obj.PermPattern = reshape(obj.PermPattern, [], ...
								log2M);
							obj.PermPattern = obj.PermPattern(:, RRS+1);
							obj.PermPattern = reshape(obj.PermPattern.', ...
								[], 1);
					end;
				end;
		end
		function OutData = StepTx(obj, InData)
			if obj.isTransparent || isempty(obj.PermPattern)
				OutData = InData;
			else
				OutData = InData(obj.PermPattern);
			end
			if isequal(obj.ModulationOrder, 128)
				OutData = [OutData; ones(84, 1)];
			end
		end
		function OutData = StepRx(obj, InData)
			if isequal(obj.ModulationOrder, 128)
				InData = InData(1:end-84);
			end
			if obj.isTransparent || isempty(obj.PermPattern)
				OutData = InData;
				return
			end
			OutData = zeros(size(InData));
			OutData(obj.PermPattern) = InData;
		end
	end
end