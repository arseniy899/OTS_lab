function Draw(DirName)
%
% ������� ���������� ������ ����������� ������� � �������� ������

    % ����������, �� ������� ����� ����� ����������
        if nargin == 0
            DirName = 'Results';
		end
		path = ['out/' DirName];
    % ������� ���������� � ���������� ����������
	    Listing = dir(path);
    % �������������� cell-������ ��� �������� ��� ������, �� ������� �����
    % ������� �������
        Names = cell(0);

    % ���� �� ���� ������ ����������
        for k = 1:length(Listing)
            % ���� ���������, ����� ��������������� ������� ��� ������ �
            % ���� ���������� mat
                if ~Listing(k).isdir
                    FName = Listing(k).name;
                    if length(FName) > 4
                        if isequal(FName(end-3:end), '.mat')
                            % ������� ��� ����� � ������
                                Names{end+1} = FName(1:end-4); %#ok<AGROW>
                        end
                    end
                end
        end

        if isempty(Names)
            error('�� ������� ����� � ������������!');
        end

    % ���������� BER � FER
        % �������� ��� ������� � ���
            f  = cell(2, 1);
            ax = cell(2, 1);
            for k = 1:2
                f{k} = figure;
                    ax{k} = axes;
            end

        % ���� �� ���� ��� ��������� ������
            for k = 1:length(Names)
                % �������� �����������
                    load([path, '\', Names{k}, '.mat'], 'Res');
                % ���������� ��� ��������� ������ ��������    
                    figure(f{1});
                        hold on;
						set(gcf,'color','w');
                        plot(Res.h2dBs, Res.NumErBits ./ Res.NumTrBits, ...
                            'LineWidth', 1, 'MarkerSize', 8, ...
                            'Marker', '.');
							
					%Save figure
					
                    figure(f{2});
                        hold on;
						set(gcf,'color','w');
                        plot(Res.h2dBs, Res.NumErFrames ./ ...
                            Res.NumTrFrames, 'LineWidth', 1, ...
                            'MarkerSize', 8, 'Marker', '.');
					
            end
			
        for k = 1:2
            figure(f{k});

            % ������� �����
                grid on;

            % ������� ������������ ������� �� ��� �������
                set(ax{k}, 'YScale', 'log');

            % �������� ������� � ��� �������
                if k == 1
                    title('BER');
                else
                    title('FER');
                end
                xlabel('{\ith}^2 (dB)');

            % ���������� ����������� BER
            % � ������ ������ ��� QAM4 � QAM16 �� ����������� 1e-6
                if k == 1
                    AddNames = cell(0);
                    h2dB = 0:0.1:10.5;
                    BER = berawgn(h2dB, 'qam', 4);
                    plot(h2dB, BER);
                    AddNames{end+1} = 'QPSK'; %#ok<AGROW>

                    h2dB = 0:0.1:14.4;
                    BER = berawgn(h2dB, 'qam', 16);
                    plot(h2dB, BER);
                    AddNames{end+1} = '16-QAM'; %#ok<AGROW>
                end

            % ������� �������
                if k == 1
                    legend([Names, AddNames], 'Interpreter', 'none');
                else
                    legend(Names, 'Interpreter', 'none');
                end
			% save to image
				if k == 1
                    saveas(gcf,[path '/BER'],'png');
                else
                    saveas(gcf,[path '/FER'],'png');
                end
			
        end
		