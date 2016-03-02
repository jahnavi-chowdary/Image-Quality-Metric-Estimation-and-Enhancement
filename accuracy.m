function [acc,z] = accuracy(w1,w2,input,target,actFunc)
    y = actFunc(w1*input');
    y = [ones(1,size(y,2));y];
    z = actFunc(w2*y);
    
    target = target';
    j = sum(abs((round(z)) - target));
    acc = (20 - j)./(20);
    
%     error = sum(abs(target - z));
%     acc = (size(target,1) - error)./(size(target,1));
    
    % [~,i1] = max(target');
    % [~,i2] = max(z);
    % n = sum(i1==i2);
    % acc = n/size(target,1)*100;
end

