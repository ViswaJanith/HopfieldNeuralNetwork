clc
clear all
close all
%3*3 matrix
%Considering the inputs and take some values converging them to given solution
%the convergence will be according to the noise
% Input data for learning
x = [1 1 1; 1 1 -1; -1 1 1];
x(:, :, 2) = [1 1 -1; 1 1 -1 ;-1 1 -1];
disp(x)

y = [1 1 -1; -1 -1 1; -1 1 1];
y(:, :, 2) = [1 -1 1; 1 1 1; -1 1 -1];
disp(y)
input=zeros(size(x,3),9);
for k=1:1:size(x,3)
  for i = 1:1:size(x,1)
     for j = 1:1:size(x,2)
         input(k,(i-1)*3+j)=x(i,j)
       end
    end
end
output=zeros(size(x,3),9);
for k=1:1:size(y,3)
  for i = 1:1:size(y,1)
     for j = 1:1:size(y,2)
         output(k,(i-1)*3+j)=y(i,j)
       end
    end
end



% Initialize weight matrix
W = zeros(size(x,1)*size(x,2), size(x,1)*size(x,2));


% Calculate weight matrix = learning
for i = 1:1:size(x,1)*size(x,2)
    for j = 1:1:size(x,1)*size(x,2)
        weight = 0;
        if (i ~= j)
            for n = 1:1:size(x,3) % no. of examples
                weight = input(n,i) .* input(n,j) + weight;                
            end
        end
        W(i,j) = weight;
    end
end

disp(W)

% Recognition
for n = 1:1:size(y,3)
    fprintf('original:')
    disp(y(:,:,n))
    iteration = 0;
    iterationOfLastChange = 0;
    propagateUnit = 0;
    flag = true;
    
    while flag
        % Counter
        iteration = iteration + 1;

        % Generate random element for the asynchronous correction
        i = randi([1 size(x,1)*size(x,2)],1,1);
        sum = 0;
        for j = 1:1:size(x,1)*size(x,2)
            sum = sum + W(i, j) * output(n,j);
        end

        % Therehold
        out = 0;
        changed = 0;
        if (sum ~= 0)
            if (sum < 0) 
                out = -1;            
            end
            if (sum > 0) 
                out = +1;            
            end
            if (out ~= output(n,i))
                changed = 1;
                output(n,i) = out;
            end
        end

        % Main condition
        if (changed == 1)
            iterationOfLastChange = iteration;
        end

        % Break condition
        if (iteration - iterationOfLastChange > 1000)
            flag = false;
        end
    end

    % Show the recognized pattern
    fprintf('arrived')

     for j = 1:1:9
         if (j==4 || j==7)
            fprintf('\n');
         end  
         fprintf('%d', output(n,j));   
     end
    fprintf('\n');
    
    fprintf('iterations:')
    disp(iterationOfLastChange)
    fprintf('\n\n----------\n\n');
end