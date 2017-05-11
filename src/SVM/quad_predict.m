function [ prediction ] = quad_predict( w, b, x)
%quad_predict Predicts class of x

prediction = sign(dot(w, x) + b);
if prediction < 0
    prediction = 0;
end

end

