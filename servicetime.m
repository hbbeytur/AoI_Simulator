%servicetime
if is+nServer > N
    is = 0;
    S = gamrnd(k,theta,1,N);
end

serler = zeros(1,nServer);
for sx=1:nServer
    is = is + 1;
    serler(sx) = S(is);
end
ser = min(serler);


ss = ser+t_;