function [fitness] = fitness_last(Pop)
fitness = zeros(1,length(Pop));
    for i =1: length(Pop)
        Td = Pop(i,1);
        Sg = Pop(i,2);
       in(i) = Simulink.SimulationInput('Farmakodynamika');
       in(i) = in(i).setBlockParameter('Farmakodynamika/Gain','Gain',num2str(Td));
       in(i) = in(i).setBlockParameter('Farmakodynamika/Gain1','Gain',num2str(Td));

       in(i) = in(i).setBlockParameter('Farmakodynamika/Gain6','Gain',num2str(Sg));


    end
        out = parsim(in,'TransferBaseWorkspaceVariables','on');

    for row = 1:length(out)
         if out(row).ErrorMessage ~= ""
            fitness(row) = 1000000000;
         end
        if size(out(row).e)> 1200
            fitness(row) = sum(abs(out(row).e(400:1200)));
        else
            fitness(row) = 1000000000;
        end
    end
end
