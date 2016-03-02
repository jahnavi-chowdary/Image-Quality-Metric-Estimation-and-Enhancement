function [acc, predicted_l] = NaiveBayes_normal(train_s, train_l, test_s, test_l)
    
    predicted_l = zeros(size(test_s,1),1);
    
    %Estimate class priors
    classes = unique(train_l);
    priors = hist((train_l),classes);
    priors = priors/sum(priors);
    
    %Get number of classes and number of features
    no_of_classes = numel(classes);
    no_of_features = size(train_s, 2);
    
    %Estimate mean and standard deviation for each class and feature
    mn = zeros(no_of_classes, no_of_features);
    stdev = zeros(no_of_classes, no_of_features);
    for c = 1:no_of_classes
        mn(c,:) = mean(train_s(train_l == classes(c),:));
        stdev(c,:) = std(train_s(train_l == classes(c),:));
    end
    
    stdev(stdev(c,:) == 0) = sqrt((size(train_s,1)-1)/12);
    
    %Classify test patterns
    no_of_test = size(test_s, 1);
    
    for t = 1:no_of_test
        for c = 1:no_of_classes
            prob_f_c = pdf('normal',test_s(t,:),mn(c,:),stdev(c,:));
            prob_c_f(c) = log(priors(c)) + sum(log(prod(prob_f_c)));
        end
        
        %Assign the class with the highest posterior probability
        [max_prob, class_index] = max(prob_c_f);
        predicted_l(t) = classes(class_index);
    end
    
    acc = sum(predicted_l == test_l)/size(test_l,1);
    predicted_l = predicted_l;
end