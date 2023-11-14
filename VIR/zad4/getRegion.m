function [error,region] = getRegion(pos,map)
    if pos(1)-2 < 1 || pos(1)+2 > size(map,1) || pos(2)-2 < 1 || pos(2)+2 > size(map,2)
        error = true;
        region = [];
    else
        error = false;
%         map(pos(1),pos(2)) = 4;
        region = map(pos(1)-2:pos(1)+2,pos(2)-2:pos(2)+2);
        
    end
end

