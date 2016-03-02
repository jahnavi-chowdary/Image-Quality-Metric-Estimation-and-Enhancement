clc;
close all;

%% Getting the Input and Output

input = finalvect_train./(10^11);
target_out = l;

randorder = randperm(60);
input = input(randorder, :);
target_out = target_out(randorder, :);


%% Initialization of variables

sse = 1000;    % sse is the Sum Squared Error   
eta = 1;                       
alpha = 0.7; 
sse_rec = [];  
input = [input ones(size(input,1),1) ];       
number_of_inputnodes = size(input,2);     
number_of_hiddennodes = 7;                    
number_of_outputnodes = size(target_out,2);    

%% Initialization of Weights

%w1 has the weights from i-th input node to the j-th hidden node
axp1 = (-1)./(sqrt(20));
bxp1 = (1)./(sqrt(20));
w1 = 1 .* ((bxp1-axp1).*rand(number_of_inputnodes,number_of_hiddennodes - 1) + axp1);

%w2 has Weight from j-th hidden node to the k-th output node
axp2 = (-1)./(sqrt(number_of_hiddennodes));
bxp2 = (1)./(sqrt(number_of_hiddennodes));
w2 = 1 .* ((bxp2-axp2).*rand(number_of_hiddennodes,number_of_outputnodes) + axp2);
       
last_delta_w1 = zeros(size(w1));             % last change in w1
last_delta_w2 = zeros(size(w2));             % last change in w2
epoch = 0;                              

%% Computation  

while sse > 0.1                        
        input_to_hidden = (double(input)) * w1;  
        hidden_act = 1./(1+exp( - input_to_hidden)); 
        hidden_with_bias = [ hidden_act ones(size(hidden_act,1),1) ];    
        hidden_to_output = hidden_with_bias * w2; 
        output_act = 1./(1+exp( - hidden_to_output)); 
        output_error = target_out - output_act;   
        sse = trace(output_error' * output_error); 
        sse_rec = [sse_rec sse]; 
        
        delta_hidden_to_output = output_error .* output_act .* (1-output_act);                                        
        delta_input_to_hidden = delta_hidden_to_output*w2' .* hidden_with_bias .* (1-hidden_with_bias);
        delta_input_to_hidden(:,size(delta_input_to_hidden,2)) = [];  
               
        % Backpropagation
        dw1 = eta * (double(input))' * delta_input_to_hidden + alpha .* last_delta_w1;   
        dw2 = eta * hidden_with_bias' * delta_hidden_to_output + alpha .* last_delta_w2;
        
        w1 = w1 + dw1; 
        w2 = w2 + dw2;    
        
        last_delta_w1 = dw1; 
        last_delta_w2 = dw2;         
        
        epoch = epoch + 1;
        if rem(epoch,50)==0     % Every 50 epochs, show how training is doing
                 disp([' Epoch ' num2str(epoch) '  SSE ' num2str(sse)]);
        end
%         if (epoch == 20000)
%             break;
%         end
end     

figure(1);
plot(sse_rec); xlabel('Epochs'); ylabel('Sum squared error (SSE)');

w1
w2
output_act;
acdeg = round(output_act);
ans = sum(sum(acdeg - target_out))

