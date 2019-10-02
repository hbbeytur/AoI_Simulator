if SarrT{I}(end) == X
    display("halaluya")
    for beeopi = 1:10
    beep;
    end
end
SarrT{I} = [SarrT{I} X];
recT{I} = [recT{I} t_+ser];

Q(I) = Q(I) - 1;
next(:,I) = [-Inf;-1];
Nsent(I) = Nsent(I) + 1;