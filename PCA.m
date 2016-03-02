function [Y] = PCA(X,K)
    [n,d]=size(X);
    
    %For mean 
    for i = 1:d
        u(i,1) = mean(X(:,i));
    end
    h = ones(1,n)';
    size(u);
    size(h);
    
    %Compute B
    B = X -  h * u';

    C=cov(B);
    [V D]=eig(C);
    L=diag(D);
    [sorted index]=sort(L,'descend');
    W=zeros(d,K);        
    for j=1:K
        W(:,j)=V(:,index(j));
    end
    Y=B*W ;
    size(Y);
end