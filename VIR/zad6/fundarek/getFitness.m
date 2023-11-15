function [fitness] = getFitness(Pop)
fitness = zeros(1,length(Pop));
    for i =1: length(Pop)
        K = [Pop(i,1)];
        T = [Pop(i,2) 1];
        Td = Pop(i,3);
       in(i) = Simulink.SimulationInput('sim_6');
       in(i) = in(i).setBlockParameter('sim_6/TransferFcn','Numerator',mat2str(K));
       in(i) = in(i).setBlockParameter('sim_6/TransferFcn','Denominator',mat2str(T));
       in(i) = in(i).setBlockParameter('sim_6/TransportDelay','Delay',mat2str(Td));
    
%        in(i) = in(i).setBlockParameter('sim_6/Gain6','Gain',num2str(Sg));


    end
        out = parsim(in,'TransferBaseWorkspaceVariables','on');

    for row = 1:length(out)
         if out(row).ErrorMessage ~= ""
            fitness(row) = 1000000000;
         end
        fitness(row) = sum(abs(out(row).e));

    end
end
