clear

num_of_runs=1

% Define your neural network parameters
% Number of neurons for each layer
n_input = 3;
h1 = 6;
h2 = 6;
n_output = 1;

W1 = zeros(h1, n_input) * sqrt(2 / (n_input + h1));
B1 = zeros(h1, 1); % Biases initialized to zero

W2 = zeros(h2, h1) * sqrt(2 / (h1 + h2));
B2 = zeros(h2, 1); % Biases initialized to zero

W3 = zeros(n_output, h2) * sqrt(2 / (h2 + n_output));

% Display the initialized matrices for confirmation
disp('W1:'), disp(W1)
disp('B1:'), disp(B1)
disp('W2:'), disp(W2)
disp('B2:'), disp(B2)
disp('W3:'), disp(W3)

T_sim=0.1




for run=1:num_of_runs
    numgen=3000	% number of generations
    lpop=50;	% number of chromosomes in population
    lstring = numel(W1) + numel(W2) + numel(W3) + numel(B1) + numel(B2);
    M=1;          % maximum of the search space
    
    
    % Population initialisation
    
    Space=[ones(1,lstring)*-M; ones(1,lstring)*M];
    Delta=Space(2,:)/300;    % additive mutation step
    
    Pop=genrpop(lpop,Space);
    
    % Main cyklus ---------------------------------
    
    for gen=1:numgen
        clc
        disp(['Progress: ' num2str((gen / numgen) * 100) '%']);
        
        for pop_num=1:size(Pop(:,1))

            % For demonstration, take the first chromosome as an example
            Chromosome = Pop(pop_num,:);
        
            % Decode chromosome to matrices and vectors
            idx = 1;
        
            % W1
            len = numel(W1);
            W1 = reshape(Chromosome(idx:idx+len-1), size(W1));
            idx = idx + len;
        
            % W2
            len = numel(W2);
            W2 = reshape(Chromosome(idx:idx+len-1), size(W2));
            idx = idx + len;
        
            % W3
            len = numel(W3);
            W3 = reshape(Chromosome(idx:idx+len-1), size(W3));
            idx = idx + len;
        
            % B1
            len = numel(B1);
            B1 = reshape(Chromosome(idx:idx+len-1), size(B1));
            idx = idx + len;
        
            % B2
            len = numel(B2);
            B2 = reshape(Chromosome(idx:idx+len-1), size(B2));

            [e{pop_num}, y{pop_num}, u{pop_num}, w{pop_num}] = sim_URO1_nC(W1, W2, W3, B1, B2);
            f1 = sum(abs(e{pop_num}).^2);
%             f2 = 0.1*sum(abs(diff(e{pop_num})))
%             f3 = 0.1*sum(abs(diff(u{pop_num})))
            Fit(pop_num)=f1;

        end
        evolution(gen)=min(Fit);
        % GA
        Best=selbest(Pop,Fit,[1,1]);   % optimum
        Old=selrand(Pop,Fit,10);      
        Work1=seltourn(Pop,Fit,5);    
        Work1 = [Work1; selsus(Pop,Fit,8)];
        Work1=[Work1; selrand(Pop,Fit,5)];      
        Work1=crossov(Work1,5,0);
        Work2=seltourn(Pop,Fit,10);
        Work2=[Work2; selsus(Pop,Fit,10)];
        Work2=mutx(Work2,0.3,Space);
        Work2=muta(Work2,0.3,Delta,Space);
        Pop=[Best;Old;Work1;Work2];
    
    end;  % gen
    
    % -------------------------------------------------
    [~,best_index]=min(Fit);
    best_pid{run}=Pop(best_index,:)
    % Best solution
    figure;
    hold on
    plot(evolution,Color='green');
    title('evo')
    xlabel('generation');
    ylabel('fitness');

    % Best solution
    figure;
    hold on
    [~,index]=min(Fit)
    plot(y{index},'b');
    plot(w{index},'g')
    title('neuro');
    xlabel('t[s]');
    ylabel('y[-]');

    figure;
    plot(u{index},'r')

    title('akcny');

    xlabel('t[s]');
    ylabel('u[-]');
end
