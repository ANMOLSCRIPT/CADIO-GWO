function [Best_score,Best_pos,cg_curve] = DIO(N,Max_iter,lb,ub,dim,fobj)

if numel(lb)==1
    lb=lb*ones(1,dim);
end

if numel(ub)==1
    ub=ub*ones(1,dim);
end

D = repmat(lb,N,1) + rand(N,dim).*repmat((ub-lb),N,1);

Lead_pos = zeros(1,dim);
Lead_score = inf;

cg_curve = zeros(1,Max_iter);

for t = 1:Max_iter

    for i = 1:N

        Flag4ub = D(i,:)>ub;
        Flag4lb = D(i,:)<lb;
        D(i,:) = D(i,:).*(~(Flag4ub+Flag4lb)) + ...
                 (lb + rand(1,dim).*(ub-lb)).*(Flag4ub+Flag4lb);

        fitness = fobj(D(i,:));

        if fitness < Lead_score
            Lead_score = fitness;
            Lead_pos = D(i,:);
        end

    end

    V = 2 - (t-1)*(2/Max_iter);

    phase = mod(floor((t-1)/(Max_iter/4)),2);

    MeanPos = mean(D);

    for i = 1:N

        r = rand;

        B = V*r^2 - V;
        C = r + sin(pi*r);

        D_lead = abs(C*Lead_pos.^2 - D(i,:).^2);

        X_lead = Lead_pos - B.*sqrt(abs(D_lead));

        Neighbor = MeanPos - D(i,:);

        w1 = rand;
        w2 = 1-w1;

        if phase==0

            if rand<0.5

                D(i,:) = lb + rand(1,dim).*(ub-lb);

            else

                D(i,:) = w1.*X_lead + ...
                         w2.*Neighbor + ...
                         0.1*randn(1,dim).*(ub-lb);

            end

        else

            D(i,:) = w1.*X_lead + ...
                     w2.*Neighbor;

        end

    end

    cg_curve(t) = Lead_score;

end

Best_score = Lead_score;
Best_pos = Lead_pos;

end