function [ prediction ] = scores( w, b, x)
%quad_predict Predicts class of x

prediction = (dot(w, x) + b);

end