function [test_targets, a_star] = SVM_test(training_set, training_labels, validation_set, ker_param)
[Dim, Nf]= size(training_set);
Dim= Dim + 1;
training_set(Dim,:) = ones(1,Nf);
validation_set(Dim,:)  = ones(1,size(validation_set,2));
training_labels(training_labels == 0) = -1;
z=training_labels;

%gaussian kernel
y	= zeros(Nf);

   for i = 1:Nf
        y(i,:)    = exp(-sum((training_set-training_set(:,i)*ones(1,Nf)).^2)'/(2*ker_param^2));
   end
 
     
   %the two rows below is just something I tried...
   nms=sum(training_set.^2);
   Ks = exp(-(nms'*ones(1,Nf) -ones(Nf,1)*nms + 2*training_set'*training_set)/(2*ker_param^2));
  
   %comparing with Adjins implementation to try figure out whats going with
   %the kernel funciton. 
%    replicate_rows = kron(x, ones(obs, 1));% replicates each row obs times
% replicate_x = repmat(x, obs, 1);
% 
% difference = replicate_x - replicate_rows;
% squared_diff = difference .^ 2; % norm = sum(xi^2)
% norm = sum(squared_diff')';
% fraction = norm ./ (2 * sigma * sigma);
% fraction = -fraction;
% new_features = exp(fraction);
   
% linear kernel
% ker_param = 1;

solver='Quadprog';
slack=2; %don't know what this is

   %Quadratic programming
   alpha_star	= quadprog(diag(z)*y'*y*diag(z), -ones(1, Nf), zeros(1, Nf), 1, z, 0, zeros(1, Nf), slack*ones(1, Nf))';
   a_star		= (alpha_star.*z)*y';
   
   %Find the bias
   sv_for_bias  = find((alpha_star > 0) & (alpha_star < slack - 0.001*slack));
   if isempty(sv_for_bias),
       bias     = 0;
   else
	   B        = z(sv_for_bias) - a_star(sv_for_bias);
       bias     = mean(B);
   end
   
   sv           = find(alpha_star > 0);
  
%Find support verctors
Nsv	    = length(sv);
if isempty(sv),
   error('No support vectors found');
else
   disp(['Found ' num2str(Nsv) ' support vectors'])
end

%Margin
b	= 1/sqrt(sum(a_star.^2));


%%%%%%CLASSIFICATION
%Classify  validation set
N   = size(validation_set, 2);
y   = zeros(1, N);
kernel='Gauss';
for i = 1:Nsv
        y		    = y + a_star(sv(i)) * exp(-sum((validation_set-training_set(:,sv(i))*ones(1,N)).^2)'/(2*ker_param^2))';
    
end

test_targets = y + bias;
test_targets = test_targets > 0;

