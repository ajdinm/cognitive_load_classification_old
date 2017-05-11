function [ Featurenorm ] = Normalization_Features( Feature )
% Normaliztion of 132*1 Features table
start=1;
stop=132;

    Featuretemp = Feature(start:stop);
    
    tempsum = sum(Featuretemp);

% Element over sum normalization
%    normtemp = (Featuretemp/tempsum);

% 0-1 range normalization with 0.1 offset
     normtemp = (Featuretemp- min(Featuretemp))/(max(Featuretemp)-min(Featuretemp))+0.1;

    Featurenorm(start:stop) = normtemp;
    Featurenorm = Featurenorm';





end

