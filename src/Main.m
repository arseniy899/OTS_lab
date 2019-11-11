function Main(FirstParamsNum, Step4ParamsNum, LogLanguage)
%
% ������� ����������� ���� ������
%   ������� ���������� ����� ���� 0, 1, 2 ��� 3. �������� �� ���������:
%	   FirstParamsNum = 1;
%	   Step4ParamsNum = 1;
%	   LogLanguage = 'English'.
%
% ������� ����������:
%   ���� ������� ������ ���� ������� ����������, �� FirstParamsNum - ������
%	   �������� ������� ������� ����������, ��� ������� ����� ���������
%	   �������������.
%   ���� ������� ���������� ��� ��� ���, �� FirstParamsNum, Step4ParamsNum
%	   - ����� ������� ������ ���������� � ��� ��� �������� � ������������
%	   ������ ����������. ���� ���� ���������� �������������, ������
%	   �����, ��� ������� ������ �� ���������� �����.
%   LogLanguage - ���� ��� ������ ��������� ������������ � ���������� ����
%	   ('English' (�� ���������) | 'English').

	% ������� command window, �������� �����
		clc;
		close all;

	% �������� ���������� ������� ����������
		if ~(nargin >= 0 && nargin <= 3)
			error(['���������� ������� ���������� Main ������ ���� ', ...
				'0, 1, 2 ��� 3. The number of input arguments to the ', ...
				'Main should be equal to 0, 1, 2 or 3.']);
		end
		
	% ��������� ���� ��� ����
		if nargin >= 0 && nargin <= 2
			LogLanguage = 'English';
		else
			if ~(strcmp(LogLanguage, 'Russian') || ...
					strcmp(LogLanguage, 'English'))
				error(['������������ �������� ���������� ', ...
					'LogLanguage! ���������� �������� ''Russian'' � ', ...
					'''English''. Invalid value of LogLanguage! ', ...
					'Valid values are ''Russian'' and ''English''.']);
			end
		end			

	% ��������� �������� FirstParamsNum, Step4ParamsNum   
		if nargin == 0
			FirstParamsNum = 1;
			Step4ParamsNum = 1;
		elseif nargin == 1
			Step4ParamsNum = 1;
		else
			% �������� ������������ �������� ��������
		end
		
	% ���������� ����������, �������� ������� ���������� �� �������� ��
	% ���������
		Params = ReadSetup(LogLanguage);

	% ��������� ������ �������� kVals - ������� ����������, ��� �������
	% ������ ���� �������� ������ (�� ������ ����)
		% ����� ���������� ������� ����������
			NumParams = length(Params);
		if nargin == 1
			kVals = FirstParamsNum;
		else
			kVals = FirstParamsNum : Step4ParamsNum : NumParams;
		end

	% �������� �������� kVals
		if (min(kVals) < 1) || (max(NumParams) > NumParams)
			if strcmp(LogLanguage, 'Russian')
				error('������������ �������� ������ ������ ���������');
			else
				error('Invalid value of number for parameters set');
			end
		end
		
	% ���� �� ������ ����������
		for k = kVals
			% ��������� �������� ���������� �� ���������
				Params{k} = SetParams(Params{k}, k, LogLanguage);

			% ����������/�������� ����������
				Params{k} = CalcAndCheckParams(Params{k}, LogLanguage);

			% ������������� ��������
				[Objs, Ruler] = PrepareObjects(Params{k}, k, ...
					NumParams, LogLanguage);

			% ������� � ����� ������������ ���������� (��� �������������)
				Ruler.StartParallel();

			% ����� ����������� ��������� ����� � ��������� ���������
				Ruler.ResetRandStreams();
				
			% ���� ��� ������ ������ ����������
				while ~Ruler.isStop
					% ��������� ���������� ����� ������
						if Ruler.NumWorkers > 1
							parfor n = 1:Ruler.NumWorkers
								Objs{n} = LoopFun(Objs{n}, Ruler, n);
							end
						else
							Objs{1} = LoopFun(Objs{1}, Ruler, 1);
						end
					% ��������� �����������
						isPointFinished = Ruler.Step(Objs);
						
					% ���������� ����������� ��� ��������� �������
					% ��������� �����
						if isPointFinished
							Ruler.Saves(Objs, Params{k});
						end
				end

			% ����� �� ������������ ���������� (��� �������������)
				if isequal(k, kVals(end))
					Ruler.StopParallel();
				end

			% �������� ���� ��������
				DeleteObjects(Objs, Ruler);
		end
% 	DrawBERAndFER()
end
function Objs = LoopFun(inObjs, Ruler, WorkerNum)
% ���� ��� ������ ������ ����������

	% ���� ��� ������� � ������ ���� handle, �.�. ���������� ��� ���������,
	% ��� �� �����, ��� ���������� ������ parfor ���� ������ �����
	% �������������� ����������� �� ����� (https://www.mathworks.com/help/
	% distcomp/objects-and-handles-in-parfor-loops.html)
		Objs = inObjs;

	% ���� �� ���������� ������
		for k = 1:Ruler.OneWorkerNumOneIterFrames(WorkerNum)
			% ����������
				% ������������� �������� ������
					Frame.TxData	   = Objs.Source.Step();
				% ����������� �����, ������������ ������
					Frame.TxEncData	= Objs.Encoder.StepTx(Frame.TxData);
				% ������������� �������� ������
					Frame.TxIntData	= Objs.Interleaver.StepTx( ...
						Frame.TxEncData);
				% ����������� �� ������������� �������

				Frame.TxModSymbols = Objs.Mapper.StepTx( ...
						Frame.TxIntData);
				% ����������� ������ RRC
					Frame.TxFiltSignal	 = Objs.RRCFilter.StepTx( ...
						Frame.TxModSymbols);
				% ������������� �������
					Frame.TxSignal	 = Objs.Sig.StepTx( ...
						Frame.TxFiltSignal);
				
			% �����
				[Frame.RxSignal, InstChannelParams] = Objs.Channel.Step(...
					Frame.TxSignal, Ruler.h2dB);

			% �������
				% �������� RRC ����������
					Frame.RxUnfilt	 = Objs.RRCFilter.StepRx( ...
						Frame.RxSignal);
				% ��������� ��������� ������� - ���������� �������������
				% ��������
					Frame.RxModSymbols = Objs.Sig.StepRx(Frame.RxUnfilt);
				% �����������
					Frame.RxIntData	= Objs.Mapper.StepRx( ...
						Frame.RxModSymbols, InstChannelParams);
				% �������� �������������
					Frame.RxEncData	= Objs.Interleaver.StepRx( ...
						Frame.RxIntData);
				% ������������� �����, ������������ ������
					Frame.RxData	   = Objs.Encoder.StepRx( ...
						Frame.RxEncData);

			% ���������� ���������� �� �������� Frame
				Objs.Stat.Step(Frame);
		end
end