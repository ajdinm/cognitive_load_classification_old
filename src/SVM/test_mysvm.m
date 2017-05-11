x = [5     1;
     6    -1;
     7     3;
     1     7;
     2     8;
     3     8];
 y = [1 1 1 -1 -1 -1]';
 [w, b] = my_fitcsvm(x, y);
 
 positive_test = [6 -5; 5 1];
 negative_test = [2 10; 3 8];
 obs_test = [positive_test;negative_test];
 
 % using quad prog
 [n, p] = size(x);
 H = eye(p);
 H(p+1, p+1) = 0;
 f = zeros(p+1, 1);
 A = -[diag(y)*x y];
 bb = -ones(n, 1);
 
 solution_q = quadprog(H, f, A, bb);
 labels_test = [1 1 -1 -1]; 
 
 results_imp = 1:4;
 results_q = 1:4;
 for i = 1:4
    results_imp(i) = sign(dot(w, obs_test(i,:)) + b) == labels_test(i);
    results_q(i) = sign(dot(solution_q([1 2]), obs_test(i,:)) + solution_q(3)) == labels_test(i);
 end
 results_imp
 results_q
