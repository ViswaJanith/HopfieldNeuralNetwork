%4 *4  matrix
% Input data for learning
x = ['O   ';  ...
     'O   ';  ...
     'O   ';  ...
     'OOOO'];  ...

x(:, :, 2) =        ...  
    ['O  O';  ...
     'O  O';  ...
     'O  O';  ...
     'OOOO'];

y= ['OO  ';
    'O   ';
    'OO  ';
    'OOO '];

y(:,:, 2) =        ...
    ['OOOO';   ...
     'O  O';
     'OO O';  ...
     'OOOO'];

% Input data for learning
input = zeros(size(x,3),16);

% Input data for recognition
notcorrect = zeros(size(y,3),16);

% Make x input data binary
for n = 1:1:size(x,3)
    for i = 1:1:4
        for j = 1:1:4
            if x(i,j,n) == 'O'
                input(n,(i-1)*4+j) = 1; 
            else 
                input(n,(i-1)*4+j) = -1;
            end
        end
    end
end

% Make y input data binary
for n = 1:1:size(y,3)
    for i = 1:1:4
        for j = 1:1:4
            if y(i,j,n) == 'O'
                notcorrect(n,(i-1)*4+j)=1;
            else 
                notcorrect(n,(i-1)*4+j)= -1;
            end
        end
    end
end

% Initialize weight matrix
W = zeros(size(x,1),size(x,2));

% Calculate weight matrix = learning
for i = 1:1:size(x,1)*size(x,2)
    for j = 1:1:16
        weight = 0;
        if (i ~= j)
            for n = 1:1:size(x,3) % no. of examples
                weight = input(n,i) .* input(n,j) + weight;                
            end
        end
        W(i,j) = weight;
    end
end

% Recognition
for n = 1:1:size(y,3)
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
            sum = sum + W(i, j) * notcorrect(n,j);
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
            if (out ~= notcorrect(n, i))
                changed = 1;
                notcorrect(n,i) = out;
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

    % Show the initial not correct input
    for i = 1:1:size(y,1)
        for j = 1:1:size(y,2)
        	fprintf('%s', y(i,j,n));
        end
        fprintf('\n');
    end
    fprintf('\n\n');
    
    % Show the recognized pattern
    for i = 1:1:size(x,1)*size(x,2)
       if i==5 || i==9 || i==13
         fprintf('\n')
       end
        if notcorrect(n,i) == 1
            fprintf('O');
        elseif notcorrect(n,i) == -1
            fprintf(' ');
        else
            fprintf('!');
        end
    end
    fprintf('\n\n----------\n\n');
end