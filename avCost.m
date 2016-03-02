function [cost] = avCost(w1,w2,input,target,actFunc)
y = actFunc(w1*input');
y = [ones(1,size(y,2));y];
z = actFunc(w2*y);
target = target';
j = target-z;
cost = 0.5*sum(sum((j.*j)))/size(input,1);
end

