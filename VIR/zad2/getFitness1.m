function[Fit]=getFitness1(Pop)

global evals

[lpop,lstring]=size(Pop);

for i=1:lpop

    x=Pop(i,:);

    Fit(i) = 0;

    for j=1:(lstring-1)
        [e,~] = sim_URO2(Pop(i,:));
        Fit(i) = sum(abs(e));
    end;

    evals=evals+1;
end;
end
