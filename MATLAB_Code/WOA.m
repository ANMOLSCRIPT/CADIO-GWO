function [BestScore,BestPos,Curve] = WOA(N,MaxIter,lb,ub,dim,fobj)

if numel(lb)==1
    lb = lb*ones(1,dim);
    ub = ub*ones(1,dim);
end

X = rand(N,dim).*(ub-lb)+lb;

BestPos = zeros(1,dim);
BestScore = inf;

Curve = zeros(MaxIter,1);

for i = 1:N

    fitness = fobj(X(i,:));

    if fitness < BestScore
        BestScore = fitness;
        BestPos = X(i,:);
    end

end

for t = 1:MaxIter

    a = 2 - 2*(t/MaxIter);

    for i = 1:N

        r1 = rand();
        r2 = rand();

        A = 2*a*r1 - a;
        C = 2*r2;

        p = rand();

        l = -1 + 2*rand();

        for j = 1:dim

            if p < 0.5

                if abs(A) < 1

                    D = abs(C*BestPos(j)-X(i,j));

                    X(i,j) = BestPos(j)-A*D;

                else

                    rand_idx = randi(N);

                    Xrand = X(rand_idx,:);

                    D = abs(C*Xrand(j)-X(i,j));

                    X(i,j) = Xrand(j)-A*D;

                end

            else

                D = abs(BestPos(j)-X(i,j));

                b = 1;

                X(i,j) = D*exp(b*l)*cos(2*pi*l) ...
                    + BestPos(j);

            end

        end

        X(i,:) = max(X(i,:),lb);
        X(i,:) = min(X(i,:),ub);

        fitness = fobj(X(i,:));

        if fitness < BestScore

            BestScore = fitness;
            BestPos = X(i,:);

        end

    end

    Curve(t) = BestScore;

end

end