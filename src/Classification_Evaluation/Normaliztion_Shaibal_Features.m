function [ Featurenorm ] = Normaliztion_Shaibal_Features( Feature )
% Normaliztion of 132*1 Features table
start=1;
stop=4;
for i = 1:33
    Featuretemp = Feature(start:stop);
    
    tempsum = sum(Featuretemp);
    for j =1:4;
        normtemp(j) = Featuretemp(j)/tempsum;
    end;
    
    Featurenorm(start:stop) = normtemp;
    Featurenorm = Featurenorm';
    start=start+4;
    stop=stop+4;
    
end;

