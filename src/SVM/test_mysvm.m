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
 labels_test = [1 1 -1 -1];
 
 results = 1:4;
 for i = 1:4
    results(i) = sign(dot(w, obs_test(i,:)) + b) == labels_test(i);
 end
 results
