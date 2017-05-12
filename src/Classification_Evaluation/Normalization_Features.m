function [ FeatureNorm ] = Normalization_Features( Feature )
% Normaliztion of 132*1 Features table
% start=1;
% stop=132;
% 
%     Featuretemp = Feature(start:stop);
%     tempsum = sum(Featuretemp);

% Element over sum normalization
%    normtemp = (Featuretemp/tempsum);

% 0-1 range normalization with 0.1 offset
MinF=min(Feature);
MaxF=max(Feature);
offset=0;
for i = 1:length(Feature)
    FeatureNorm(i) = ((Feature(i)-MinF)/(MaxF-MinF))+offset;
end

end

