function [fitness] = getFitness1(Pop)
fitness = zeros(1,length(Pop));
    for i =1: length(Pop)
        num = [Pop(i,1)];
        den = [1 Pop(i,2) Pop(i,3)];

       in(i) = Simulink.SimulationInput('sim_6a');
       in(i) = in(i).setBlockParameter('sim_6a/TransferFcn','Numerator',mat2str(num));
       in(i) = in(i).setBlockParameter('sim_6a/TransferFcn','Denominator',mat2str(den));
   

    end
        out = parsim(in,'TransferBaseWorkspaceVariables','on');

    for row = 1:length(out)
         if out(row).ErrorMessage ~= ""
            fitness(row) = 1000000000;
            continue;
         end
        fitness(row) = sum(abs(out(row).e).^2);

    end
end



