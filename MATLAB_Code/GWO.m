function [BestScore,BestPos,Curve] = GWO(N,MaxIter,lb,ub,dim,fobj)

if numel(lb)==1
    lb = lb*ones(1,dim);
    ub = ub*ones(1,dim);
end

AlphaPos = zeros(1,dim);
AlphaScore = inf;

BetaPos = zeros(1,dim);
BetaScore = inf;

DeltaPos = zeros(1,dim);
DeltaScore = inf;

X = rand(N,dim).*(ub-lb)+lb;

Curve = zeros(MaxIter,1);

for t = 1:MaxIter

    for i = 1:N

        X(i,:) = max(X(i,:),lb);
        X(i,:) = min(X(i,:),ub);

        fitness = fobj(X(i,:));

        if fitness < AlphaScore

            DeltaScore = BetaScore;
            DeltaPos = BetaPos;

            BetaScore = AlphaScore;
            BetaPos = AlphaPos;

            AlphaScore = fitness;
            AlphaPos = X(i,:);

        elseif fitness < BetaScore

            DeltaScore = BetaScore;
            DeltaPos = BetaPos;

            BetaScore = fitness;
            BetaPos = X(i,:);

        elseif fitness < DeltaScore

            DeltaScore = fitness;
            DeltaPos = X(i,:);

        end

    end

    a = 2 - t*(2/MaxIter);

    for i = 1:N

        for j = 1:dim

            r1 = rand();
            r2 = rand();

            A1 = 2*a*r1 - a;
            C1 = 2*r2;

            D_alpha = abs(C1*AlphaPos(j)-X(i,j));
            X1 = AlphaPos(j)-A1*D_alpha;

            r1 = rand();
            r2 = rand();

            A2 = 2*a*r1 - a;
            C2 = 2*r2;

            D_beta = abs(C2*BetaPos(j)-X(i,j));
            X2 = BetaPos(j)-A2*D_beta;

            r1 = rand();
            r2 = rand();

            A3 = 2*a*r1 - a;
            C3 = 2*r2;

            D_delta = abs(C3*DeltaPos(j)-X(i,j));
            X3 = DeltaPos(j)-A3*D_delta;

            X(i,j) = (X1 + X2 + X3)/3;

        end

    end

    Curve(t) = AlphaScore;

end

BestScore = AlphaScore;
BestPos = AlphaPos;

end