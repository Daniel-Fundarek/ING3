function [fitness] = fitness(Pop)
fitness = zeros(1,length(Pop));
    for i =1: length(Pop)
        p2 = Pop(i,1);
        Si = Pop(i,2);
        Sg = Pop(i,3);

       in(i) = Simulink.SimulationInput('sim_boganov_model');
       in(i) = in(i).setBlockParameter('sim_boganov_model/Gain1','Gain',num2str(p2*Si));
       in(i) = in(i).setBlockParameter('sim_boganov_model/Gain','Gain',num2str(p2));
       in(i) = in(i).setBlockParameter('sim_boganov_model/Constant2','Value',num2str(Sg));
    end
        out = parsim(in,'TransferBaseWorkspaceVariables','on');

    for row = 1:length(out)
         if out(row).ErrorMessage ~= ""
            fitness(row) = 1000000000;
         end
        fitness(row) = sum(abs(out(row).e));
    end
end