function [fitness] = getFitnessPid(Pop)
fitness = zeros(1,length(Pop));
    for i =1: length(Pop)
        P = Pop(i,1);
        I = Pop(i,2);
        D = Pop(i,3);
       in(i) = Simulink.SimulationInput('sim_6_gen');
       in(i) = in(i).setBlockParameter('sim_6_gen/PID','P',num2str(P));
       in(i) = in(i).setBlockParameter('sim_6_gen/PID','I',num2str(I));
       in(i) = in(i).setBlockParameter('sim_6_gen/PID','D',num2str(D));
   
    end
        out = parsim(in,'TransferBaseWorkspaceVariables','on');

    for row = 1:length(out)
         if out(row).ErrorMessage ~= ""
            fitness(row) = 1000000000;
            continue;
         end
         
        fitness(row) = sum(abs(out(row).e))+sum(abs(out(row).du));
%         fitness(row) = fitness(row) +sum(abs(out(row).e) > 1.5)*100; %
%         first 10 Second 1.5 Third without  this
%         fitness(row) = fitness(row) +sum(out(row).e > 0)*10; %

        fitness(row) = fitness(row) +sum(out(row).u > 10)*100;
   
    end
end
