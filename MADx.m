clear
taves = [];
tthrs = [];
arrRate = [0.1:0.2:1.5 2:2:10];

for type = [1] % 1:MAD-preemptive 2:MAD-nonpreemptive
for k = 1
thrs = [];
aves = [];
for arr_rate = arrRate
for fs = 1
%%
nServer = 1;
fs;
num_arr = 10000; % number of arrival for each flow
num_flow = fs; % number of flow
arr_rate; % arrival rate
ser_rate=fs;
k; % shape parameter
theta = 1/(ser_rate*k);
N = num_arr*num_flow; % number of total packets
%%
arr = exprnd(1/arr_rate,num_flow,num_arr);
q = cumsum(arr,2);
arrT = zeros(2,N);
ind = ones(1,num_flow);
for i=1:N
    comp = zeros(1,num_flow);
    for l=1:num_flow, comp(l) = q(l,ind(l)); end
    [x, f] = min(comp);
    arrT(:,i) = [x;f];
    if ind(f) < num_arr, ind(f) = ind(f) + 1;
    %else q(f,ind(f)) = Inf; end % Tüm flowları bitir   
    else arrT = arrT(:,1:i); N = size(arrT,2); break; end          % Bir flow bitince çık
end
arrT(1,:) = arrT(1,:) + 1;

% arr = exprnd(1/arr_rate,1,num_arr);
% arrT = cumsum(arr,2)+1;
% w = repmat(arrT,num_flow,1); arrT = [w(:)';repmat(1:num_flow,1,num_arr);];
%%
is = 0;  %servisi güncelleyen değişken (bak servicetime)
S = gamrnd(k,theta,1,N);
%%
SarrT = cell(num_flow,1);
recT = cell(num_flow,1);

for l = 1:num_flow, lastSent(l)= rand(); SarrT{l} = lastSent(l);  end
recT(:) = {1};

Q = zeros(1,num_flow);
Qsize = Inf;
Nsent = zeros(1,num_flow);

fprintf('type: %d, fs: %d, k: %d, arr_rate: %.2f\n',type,fs,k,arr_rate)
%%
qdan = 0;
next = [ones(1,num_flow)*-Inf; ones(1,num_flow)*-1];

i = 1;
nextpacket;
Q(n) = Q(n) + 1; Q = min(max(Q, 0),Qsize);
t_ = arrT(1,i);
qdan = 0;


while i < N
    servicetime;
    if ser+t_ < arrT(1,i+1)
        switch(type)
            case {1,2} % MAD
                if qdan == 0
                    servis;
                elseif (qdan == 1)
                    [mQ, mI] = max(Q);
                    Q(mI) = Q(mI) - 1; Nsent(mI) = Nsent(mI) + 1;
                end
                if Q == 0
                    i = i + 1;
                    nextpacket;
                    Q(n) = Q(n) + 1; Q = min(max(Q, 0),Qsize);
                    t_ = arrT(1,i);
                    qdan = 0;
                else
                    if next < 0
                        qdan = 1;
                    else
                        ad = zeros(1,num_flow);
                        for p = 1:size(next,2), ad(p) = next(1,p)-SarrT{p}(end); end
                        [AD,I]=max(ad); % I: flow
                        X = next(1,I); % X: packet arrival
                        qdan = 0;
                    end
                    t_ = t_ + ser;
                end
            case {3,4}  % normal
                if qdan == 0
                    servis;
                elseif (qdan == 1)
                    [mQ, mI] = max(Q);
                    Q(mI) = Q(mI) - 1; Nsent(mI) = Nsent(mI) + 1;
                end
                if Q == 0
                    i = i + 1;
                    X = arrT(1,i); I = arrT(2,i);
                    Q(I) = Q(I) + 1; Q = min(max(Q,0),Qsize);
                    t_ = arrT(1,i);
                    qdan = 0;
                else
                    qdan = 1;
                    t_ = t_ + ser;
                end
            case {5,6}
                if qdan == 0
                    servis;
                elseif (qdan == 1)
                    [mQ, mI] = max(Q);
                    Q(mI) = Q(mI) - 1; Nsent(mI) = Nsent(mI) + 1;
                end
                if Q == 0
                    i = i +1;
                    nextpacket;
                    Q(n) = Q(n) + 1; Q = min(max(Q, 0),Qsize);
                    t_ = arrT(1,i);
                    qdan = 0;
                else
                    if next < 0
                        qdan = 1;
                    else
                        cage = Inf*ones(1,num_flow);
                        for p = find(next(2,:) ~=-1), cage(p) = SarrT{p}(end); end
                        [AD,I] = min(cage);
                        X = next(1,I);
                        qdan = 0;
                    end
                    t_ = t_ + ser;
                end
        end
    else
        switch(type)
            case 1 %prmpt MAD
                if qdan == 0
                    ki = 1;
                    premad = 0;
                    while i+ki <= N && ser+t_ > arrT(1,i+ki)
                        n = arrT(2,ki+i); % sonraki paketin hedefi
                        Q(n) = Q(n) + 1; Q = min(max(Q, 0),Qsize);
                        next(:,n) = arrT(:,i+ki);
                        if AD < (arrT(1,ki+i)-SarrT{n}(end)) % preemption
                            premad = 1;
                            break;
                        end
                        ki = ki + 1;
                    end
                    if premad == 0
                        servis;
                        i = i + ki - 1;
                        nextpacket;
                        t_ = t_ + ser;
                    elseif premad == 1
                        i = i + ki;
                        nextpacket;
                        t_ = arrT(1,i);
                        premad = 0;
                    end
                elseif qdan == 1
                    i = i + 1;
                    nextpacket;
                    Q(n) = Q(n) + 1; Q = min(max(Q, 0),Qsize);
                    t_ = arrT(1,i);
                end
                qdan = 0;
            case 2 %nonprmpt MAD
                if qdan == 0
                    servis;
                else
                    [mQ, mI] = max(Q);
                    Q(mI) = Q(mI) - 1; Nsent(mI) = Nsent(mI) + 1;
                end
                ki = 1;
                while i+ki <= N && ser+t_ > arrT(1,i+ki)
                    n = arrT(2,ki+i); % sonraki paketin hedefi
                    Q(n) = Q(n) + 1; Q = min(max(Q, 0),Qsize);
                    next(:,n) = arrT(:,i+ki);
                    ki = ki + 1;
                end
                i = i + ki - 1;
                ad = zeros(1,num_flow);
                for p = 1:size(next,2), ad(p) = next(1,p)-SarrT{p}(end); end
                [AD,I]=max(ad); % I: flow
                X = next(1,I); % X: packet arrival
                t_ = t_ + ser;
                qdan = 0;
            case 3 % normal preemptive
                i = i + 1;
                X = arrT(1,i);
                t_ = arrT(1,i); I = arrT(2,i);
                Q(I) = Q(I) + 1; Q = min(max(Q, 0),Qsize);
                qdan = 0;
            case 4 % normal nonprmpt
                if qdan == 0 % Service
                    servis;
                elseif qdan == 1
                    [mQ, mI] = max(Q);
                    Q(mI) = Q(mI) - 1; Nsent(mI) = Nsent(mI) + 1;
                end
                
                ki = 1; % Next Packet
                while i+ki <= N && ser+t_ > arrT(1,i+ki)
                    pI = arrT(2,ki+i);
                    Q(pI) = Q(pI) + 1; Q = min(max(Q, 0),Qsize);
                    ki = ki + 1;
                end
                i = i + ki - 1;
                X = arrT(1,i);
                t_ = t_ + ser; I = arrT(2,i);
                qdan = 0;
            case 5 % MAF-preemptive
                if qdan == 0
                    ki = 1;
                    premad = 0;
                    while i+ki <= N && ser+t_ > arrT(1,i+ki)
                        n = arrT(2,ki+i); % sonraki paketin hedefi
                        Q(n) = Q(n) + 1; Q = min(max(Q, 0),Qsize);
                        next(:,n) = arrT(:,i+ki);
                        if AD >= SarrT{n}(end) % preemption
                            premad = 1;
                            break;
                        end
                        ki = ki + 1;
                    end
                    if premad == 0
                        servis;
                        i = i + ki - 1;
                        nextpacket;
                        t_ = t_ + ser;
                    elseif premad == 1
                        i = i + ki;
                        nextpacket;
                        t_ = arrT(1,i);
                        premad = 0;
                    end
                elseif qdan == 1
                    i = i + 1;
                    nextpacket;
                    Q(n) = Q(n) + 1; Q = min(max(Q, 0),Qsize);
                    t_ = arrT(1,i);
                end
                qdan = 0;
            case 6 % MAF nonpreemptive
                if qdan == 0
                    servis;
                else
                    [mQ, mI] = max(Q);
                    Q(mI) = Q(mI) - 1; Nsent(mI) = Nsent(mI) + 1;
                end
                ki = 1;
                while i+ki <= N && ser+t_ > arrT(1,i+ki)
                    n = arrT(2,ki+i); % sonraki paketin hedefi
                    Q(n) = Q(n) + 1; Q = min(max(Q, 0),Qsize);
                    next(:,n) = arrT(:,i+ki);
                    ki = ki + 1;
                end
                i = i + ki - 1;
                cage = Inf*ones(1,num_flow);
                for p = find(next(2,:) ~=-1), cage(p) = SarrT{p}(end); end
                [AD,I] = min(cage);
                X = next(1,I);
                t_ = t_ + ser;
                qdan = 0;
        end
    end
end
%%
%% Throughput
thr = sum(Nsent);
% for l = 1:num_flow, thr = thr + size(recT{l},2); end % age effective packets
thr = thr / (N)
thrs = [thrs thr];

%% Average Age

aveAge = zeros(num_flow,1);

for l = 1: num_flow
    a = SarrT{l};
    r = recT{l};
    age = sum(0.5*(2*r(2:end)-(a(1:end-1)+a(2:end))).*(diff(a)));
    aveAge(l) = age / r(end);    
end
total_ave = mean(aveAge)
aves = [aves total_ave];

for l = 1: num_flow
    a = SarrT{l};
    r = recT{l};
    age = sum(0.5*(2*r(2:end)-(a(1:end-1)+a(2:end))).*(diff(a)));
    aveAge(l) = age / r(end);    
    %mean(diff(a))
end

end
end
taves = [taves ; aves];
tthrs = [tthrs ; thrs];
end
end