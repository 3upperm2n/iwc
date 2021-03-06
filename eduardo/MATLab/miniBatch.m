 function [params, J_history] = miniBatch(f,params,X,y,epsilon,alpha,batch_size,epochs)
 %  This is a mini-batch learnibg algorithm with adaptative learning rates
 %  and momentum

% Setup some useful variables
m=size(X,1);
numbatches=floor(m/batch_size); % Define number of batches
J_history=zeros(epochs,1);

Theta_velocity=zeros(size(params));
local_gain=ones(size(params));
previous_grad=ones(size(params));

for e=1:epochs
    perm=randperm(m); % Random permutation of the dataset in each epoch
    X=X(perm,:);
    y=y(perm,:);
    for b=1:numbatches
        Xbatch=X((b-1)*batch_size+1:b*batch_size,:);
        ybatch=y((b-1)*batch_size+1:b*batch_size,:);
        [J_history(e), Theta_grad]=f(params,Xbatch,ybatch);
        
        % Adaptive learning rate: if the previous and actual grads have the same signal the local gain is added to 0.05,
        % if their signal is not the same, the local gain is multiplied by 0.95.
        previous_grad=Theta_grad.*previous_grad;
        local_gain(previous_grad>0)=local_gain(previous_grad>0)+0.05;
        local_gain(previous_grad<=0)=local_gain(previous_grad<=0).*0.95;
        previous_grad=Theta_grad;
        
        % Momentum is applied here: alpha is the momentum hyperparameter.
        Theta_velocity=alpha.*Theta_velocity-(epsilon*local_gain).*Theta_grad;
        params=params+Theta_velocity;
    end
    fprintf('Iteration %4i | Cost: %4.6e\r', e, J_history(e));
end

end
