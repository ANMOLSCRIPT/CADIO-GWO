function [Best_score,Best_pos,cg_curve] = ...
CADIO_GWO(N,Max_iter,lb,ub,dim,fobj)

if numel(lb)==1
    lb=lb*ones(1,dim);
end

if numel(ub)==1
    ub=ub*ones(1,dim);
end

%% ==========================================
%% CHAOTIC INITIALIZATION (LOGISTIC MAP)
%% ==========================================

z = rand;

Chaos = zeros(N,dim);

for i = 1:N
    for j = 1:dim

        z = 4*z*(1-z);

        Chaos(i,j)=z;

    end
end

X = lb + Chaos.*(ub-lb);

%% ==========================================
%% INITIAL FITNESS
%% ==========================================

Fitness=zeros(N,1);

for i=1:N
    Fitness(i)=fobj(X(i,:));
end

[Fitness,idx]=sort(Fitness);

X=X(idx,:);

Best_score=Fitness(1);
Best_pos=X(1,:);

cg_curve=zeros(1,Max_iter);

%% ==========================================
%% MAIN LOOP
%% ==========================================

for t=1:Max_iter

    %% NONLINEAR DECAY

    a = 2 * exp(-4 * (t/Max_iter));

    %% ADAPTIVE ELITE SIZE

    EliteSize = max(3,...
        round(10-7*(t/Max_iter)));

    %% SORT POPULATION

    [Fitness,idx]=sort(Fitness);

    X=X(idx,:);

    Elite = X(1:EliteSize,:);

    Alpha = Elite(1,:);

    MeanPos = mean(X);

    for i=1:N

        %% ======================================
        %% RANDOM ELITE SELECTION
        %% ======================================

        EliteLeader = ...
            Elite(randi(EliteSize),:);

        %% ======================================
        %% DIO COMPONENT
        %% ======================================

        r=rand;

        B=a*(2*r-1);

        C=1+r;

        eta = 0.4*(1-t/Max_iter);

        D_lead=abs(C*EliteLeader-X(i,:));

        X_dio=EliteLeader-B.*D_lead + eta*rand*(Best_pos - X(i,:));

        EliteMean = mean(Elite,1);

        X_pack = EliteMean - r.*abs(EliteMean-X(i,:));

        X_dio=0.8*X_dio+0.2*X_pack;

        %% ======================================
        %% GWO COMPONENT
        %% ======================================

        if EliteSize >= 3

            Alpha=Elite(1,:);
            Beta=Elite(2,:);
            Delta=Elite(3,:);

        else

            Alpha=Elite(1,:);
            Beta=Elite(1,:);
            Delta=Elite(1,:);

        end

        r1=rand(1,dim);
        r2=rand(1,dim);

        A1=2*a*r1-a;
        C1=2*r2;

        D_alpha=abs(C1.*Alpha-X(i,:));

        X1=Alpha-A1.*D_alpha;

        r1=rand(1,dim);
        r2=rand(1,dim);

        A2=2*a*r1-a;
        C2=2*r2;

        D_beta=abs(C2.*Beta-X(i,:));

        X2=Beta-A2.*D_beta;

        r1=rand(1,dim);
        r2=rand(1,dim);

        A3=2*a*r1-a;
        C3=2*r2;

        D_delta=abs(C3.*Delta-X(i,:));

        X3=Delta-A3.*D_delta;

        X_gwo=(X1+X2+X3)/3;

        %% ======================================
        %% ADAPTIVE HYBRIDIZATION
        %% ======================================

        %w = 0.3 + 0.7*sqrt(t/Max_iter);

        w = 0.85 - 0.15 * (t/Max_iter); 

        X_new = (1-w)*X_dio + w*X_gwo;
               
        %% BOUNDARY CONTROL

        X_new=max(X_new,lb);
        X_new=min(X_new,ub);

        X(i,:)=X_new;
    end

    %% FITNESS UPDATE

    for i=1:N

        Fitness(i)=fobj(X(i,:));

    end

    [CurrentBest,ind]=min(Fitness);

    if CurrentBest < Best_score

        Best_score=CurrentBest;

        Best_pos=X(ind,:);

    end

    cg_curve(t)=Best_score;

end

end