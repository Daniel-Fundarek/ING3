function [Pop] = migrate_best(Pop)
    migration_pop = [];
    [~, pop_count] = size(Pop);

    for pop_ind =2:pop_count
        migration_pop = [migration_pop;Pop{pop_ind}(1,:)];
    end

    [rows,columns] = size(Pop{1});
    r = randperm(rows-1,pop_count-1);
    Pop{1}(r,:) = [];
    Pop{1} = [Pop{1};migration_pop];

end