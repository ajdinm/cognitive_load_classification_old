function HRVNonlinearFeatures = HRVNonlinearFeatures(filename, startRow, endRow)
% Initialize variables.
delimiter = ';';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%q%q%q%q%q%q%q%q%q%[^\n\r]';

% Open the text file.
fileID = fopen(filename,'r');

% Read columns of data according to the format.

dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

% Close the text file.
fclose(fileID);

% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,3,4,5,6,7,8,9]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end

% Split data into numeric and string columns.
rawNumericColumns = raw(:, [1,3,4,5,6,7,8,9]);
rawStringColumns = string(raw(:, 2));


% Make sure any text containing <undefined> is properly converted to an <undefined> categorical
idx = (rawStringColumns(:, 1) == '<undefined>');
rawStringColumns(idx, 1) = '';

% Create output variable
HRVNonlinearFeatures = table;
HRVNonlinearFeatures.id = cell2mat(rawNumericColumns(:, 1));
HRVNonlinearFeatures.taskname = categorical(rawStringColumns(:, 1));
HRVNonlinearFeatures.tasksequence = cell2mat(rawNumericColumns(:, 2));
HRVNonlinearFeatures.istask = cell2mat(rawNumericColumns(:, 3));
HRVNonlinearFeatures.sd1 = cell2mat(rawNumericColumns(:, 4));
HRVNonlinearFeatures.sd2 = cell2mat(rawNumericColumns(:, 5));
HRVNonlinearFeatures.dfaalphaall = cell2mat(rawNumericColumns(:, 6));
HRVNonlinearFeatures.dfaalpha1 = cell2mat(rawNumericColumns(:, 7));
HRVNonlinearFeatures.dfaalpha2 = cell2mat(rawNumericColumns(:, 8));

