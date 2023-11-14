function [evolution,Pop] = new_generation1(Pop,gen,Space,Delta,evolution)
    % calculate fitness
    [Fit]=getFitness(Pop);
    % Record current best fitness from population
    evolution(gen)=min(Fit);	% convergence graph of the solution
    % GA
    Best=selbest(Pop,Fit,[1,1]);   % optimum
    Old=selrand(Pop,Fit,10);      
    Work1=seltourn(Pop,Fit,5);    
    Work1 = [Work1; selsus(Pop,Fit,8)];
    Work1=[Work1; selrand(Pop,Fit,5)];      
    Work1=crossov(Work1,2,0);
    Work2=seltourn(Pop,Fit,10);
    Work2=[Work2; selsus(Pop,Fit,10)];
    Work2=mutx(Work2,0.3,Space);
    Work2=muta(Work2,0.2,Delta,Space);
    Pop=[Best;Old;Work1;Work2];
end