clc
clear all
close all
%question 1
%Considering the inputs and take some values converging them to given solution
%the convergence will be according to the noise
% Input data for learning
x = [1 1 1 1];
x(:, :, 2) = [1 1 1 -1];
disp(x)

y = [1 1 -1 1];
y(:, :, 2) = [1 -1 1 -1];
y(:, :, 3) = [-1 1 1 1];
y(:, :, 4) = [1 -1 1 1];
y(:, :, 5) = [-1 -1 1 1];
y(:, :, 6) = [1 -1 -1 -1];
disp(y)

% Initialize weight matrix
W = zeros(size(x,1)*size(x,2), size(x,1)*size(x,2));

% Calculate weight matrix = learning
for i = 1:1:size(x,1)*size(x,2)
    for j = 1:1:size(x,1)*size(x,2)
        weight = 0;
        if (i ~= j)
            for n = 1:1:size(x,3) % no. of examples
                weight = x(1,i,n) .* x(1,j,n) + weight;                
            end
        end
        W(i,j) = weight;
    end
end

disp(W)

% Recognition
for n = 1:1:size(y,3)
    fprintf('original:')
    disp(y(1,:,n))
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
            sum = sum + W(i, j) * y(1,j,n);
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
            if (out ~= y(1,i,n))
                changed = 1;
                y(1,i,n) = out;
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
    disp(y(1,:,n))
    fprintf('iterations:')
    disp(iterationOfLastChange)
    fprintf('\n\n----------\n\n');
end