function [posPool, bool] = pntInPool(pnt, pool)

bool = 0;
posPool = [0 0 0];

for p = 1: size(pool,1)
    if sum( double(pool(p,:) == pnt) ) == 3
        bool = 1;
        posPool = p;
        return 
    end
end

return 

end