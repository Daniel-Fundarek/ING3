function [fitness] = fitness_last(Pop)
fitness = zeros(1,length(Pop));
    for i =1: length(Pop)
        p2 = Pop(i,1);
        Si = Pop(i,2);
        v=281.218;
       in(i) = Simulink.SimulationInput('Farmakodynamika');
       in(i) = in(i).setBlockParameter('Farmakodynamika/Gain9','Gain',num2str(p2));
       in(i) = in(i).setBlockParameter('Farmakodynamika/Gain10','Gain',num2str(Si));


    end
        out = parsim(in,'TransferBaseWorkspaceVariables','on');

    for row = 1:length(out)
         if out(row).ErrorMessage ~= ""
            fitness(row) = 1000000000;
         end
        fitness(row) = sum(abs(out(row).e));
    end
end
