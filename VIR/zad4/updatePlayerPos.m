function [newPos] = updatePlayerPos(pos,heading)
    if heading==0
        newPos = [pos(1),pos(2)+1];
    elseif heading == 1
        newPos = [pos(1)-1,pos(2)];
    elseif heading == 2
        newPos = [pos(1),pos(2)-1];
    else 
        newPos = [pos(1)+1,pos(2)];
    end
end
