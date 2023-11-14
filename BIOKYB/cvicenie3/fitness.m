function [fitness] = fitness(Pop)
fitness = zeros(1,length(Pop));
    for i =1: length(Pop)
        Ti = Pop(i,1);
        Vi = Pop(i,2);
        ki = Pop(i,3);
        v=281.218;
       in(i) = Simulink.SimulationInput('Farmakokinetika');
       in(i) = in(i).setBlockParameter('Farmakokinetika/Gain','Gain',num2str(1/Ti));
       in(i) = in(i).setBlockParameter('Farmakokinetika/Gain1','Gain',num2str(1/Ti));
       in(i) = in(i).setBlockParameter('Farmakokinetika/Gain2','Gain',num2str(ki));
       in(i) = in(i).setBlockParameter('Farmakokinetika/Gain3','Gain',num2str(1/Vi));

       in(i) = in(i).setBlockParameter('Farmakokinetika/Integrator','InitialCondition',num2str(Ti*v));
       in(i) = in(i).setBlockParameter('Farmakokinetika/Integrator1','InitialCondition',num2str(Ti*v));
       in(i) = in(i).setBlockParameter('Farmakokinetika/Integrator2','InitialCondition',num2str(v/(Vi*ki)));
    end
        out = parsim(in,'TransferBaseWorkspaceVariables','on');

    for row = 1:length(out)
         if out(row).ErrorMessage ~= ""
            fitness(row) = 1000000000;
         end
        fitness(row) = sum(abs(out(row).e));
    end
end
