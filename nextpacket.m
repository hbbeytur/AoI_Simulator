switch(type)
    case {1,2,3,4}
        n = arrT(2,i);
        next(:,n) = arrT(:,i);
        
        ad = zeros(1,num_flow);
        for p = 1:size(next,2), ad(p) = next(1,p)-SarrT{p}(end); end
        [AD,I]=max(ad); % I: flow
        X = next(1,I); % X: packet arrival
    case {5,6}
        n = arrT(2,i);
        next(:,n) = arrT(:,i);
        
        cage = Inf*ones(1,num_flow);
        for p = find(next(2,:) ~=-1), cage(p) = SarrT{p}(end); end
        [AD,I] = min(cage);
        X = next(1,I);
end