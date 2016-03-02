% function [w1,w2] = backprop(fix_w1,fix_w2,input,target,hiddenNum,actFunc)
function [init_w1,init_w2,w1,w2] = backprop(input,target,hiddenNum,actFunc)
    eta = 1;
    alpha = 0.8;
    w1 = randn(hiddenNum,size(input,2));
    w2 = randn(size(target,2),hiddenNum+1);
    init_w1 = w1;
    init_w2 = w2;
    
%     w1 = fix_w1;
%     w2 = fix_w2;

    pw1 = zeros(hiddenNum,size(input,2));
    pw2 = zeros(size(target,2),hiddenNum+1);
    
    k=0;
    while(1)
        k = k+1;
        i = mod(k-1,size(input,1))+1;
        [z,y] = output(w1,w2,input(i,:),actFunc);
        delta2 = (target(i,:)-z).*z.*(1-z);
        deltaw2 = eta*delta2'*y;
        delta1 = (delta2*w2(:,2:hiddenNum+1)).*y(2:hiddenNum+1).*(1-y(2:hiddenNum+1));
        deltaw1 = eta*delta1'*input(i,:);
        w1 = w1+deltaw1+alpha*pw1;
        w2 = w2+deltaw2+alpha*pw2;
        pw1 = deltaw1;
        pw2 = deltaw2;
        accuracy(w1,w2,input,target,actFunc);
        err(1,k) = avCost(w1,w2,input,target,actFunc);
%         avCost(w1,w2,input,target,actFunc)
        if abs(avCost(w1,w2,input,target,actFunc))<= 0.1
            break;
        end
    end
    x = [1:k];
    y = err;
    figure ; plot(x,y);
end

