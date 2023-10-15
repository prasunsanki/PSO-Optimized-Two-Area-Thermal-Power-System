clc;
clear;
close all;

%% Problem Definition

                                                            nVar=3;            % Number of Decision Variables

VarSize=[1 nVar];    % Size of Decision Variables Matrix

VarMin = 0.001;      % Lower Bound of Variables
VarMax = 10;         % Upper Bound of Variables


%% PSO Parameters

MaxIt= 100;      % Maximum Number of Iterations

nPop=100;        % Population Size (Swarm Size)

% PSO Parameters
w=1;            % Inertia Weight
wdamp=0.99;     % Inertia Weight Damping Ratio
c1 = 1.5;         % Personal Learning Coefficient
c2 = 2.0;         % Global Learning Coefficient

% Velocity Limits
VelMax=0.2*(VarMax-VarMin);
VelMin=-VelMax;

%% Initialization

empty_particle.Position=[];
empty_particle.Cost=[];
empty_particle.Velocity=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];

particle=repmat(empty_particle,nPop,1);

GlobalBest.Cost=inf;
                                                                    k = zeros(nPop,nVar);

for i=1:nPop
    
    % Initialize Position
    particle(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    % Initialize Velocity
    particle(i).Velocity=zeros(VarSize);
    
    
    
    
    
    
                                                    k(i,:) =  particle(i).Position;
                                                    kp = k(i,1);
                                                    ki = k(i,2);
                                                    kd = k(i,3);
                                                    %kp1 = k(i,4);
                                                    %ki1 = k(i,5);
                                                    %kd1 = k(i,6);
sim('prs_agc',[0 100]);
a=length(I7);
ISE=I7(a); 

    % Evaluation
                                                    particle(i).Cost=ISE;
                                                    
    % Update Personal Best
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    
    % Update Global Best
    if particle(i).Best.Cost<GlobalBest.Cost
        
        GlobalBest=particle(i).Best;
        
    end
    disp(['No of Population ' num2str(i)]);
    
end
BestCost=zeros(MaxIt,1);

%% PSO Main Loop

for it=1:MaxIt
    
    for i= 1:nPop        
       % Update Velocity
        particle(i).Velocity = w*particle(i).Velocity ...
            +c1*rand(VarSize).*(particle(i).Best.Position-particle(i).Position) ...
            +c2*rand(VarSize).*(GlobalBest.Position-particle(i).Position);
        
        % Apply Velocity Limits
        particle(i).Velocity = max(particle(i).Velocity,VelMin);
        particle(i).Velocity = min(particle(i).Velocity,VelMax);
        
        % Update Position
        particle(i).Position = particle(i).Position + particle(i).Velocity;
        
        % Velocity Mirror Effect
        IsOutside=(particle(i).Position<VarMin | particle(i).Position>VarMax);
        particle(i).Velocity(IsOutside)=-particle(i).Velocity(IsOutside);
        
        % Apply Position Limits
        particle(i).Position = max(particle(i).Position,VarMin);
        particle(i).Position = min(particle(i).Position,VarMax);
              
                                                    k(i,:) =  particle(i).Position;
                                                    kp = k(i,1);
                                                    ki = k(i,2);
                                                    kd = k(i,3);
                                                    %kp1 = k(i,4);
                                                    %ki1 = k(i,5);
                                                    %kd1 = k(i,6);
                                                    

sim('prs_agc.mdl',[0 100]);
a=length(I7);
ISE=I7(a); 
    
    
    % Evaluation
                                                    particle(i).Cost=ISE;
                                                         
                                                    
                                                    
        
        % Update Personal Best
        if particle(i).Cost<particle(i).Best.Cost
            
            particle(i).Best.Position=particle(i).Position;
            particle(i).Best.Cost=particle(i).Cost;
            
            % Update Global Best
            if particle(i).Best.Cost<GlobalBest.Cost
                
                GlobalBest=particle(i).Best;
                
            end
            
        end
    end        
   
    
    BestCost(it)=GlobalBest.Cost;
    
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
    w=w*wdamp;
    
end

BestSol = GlobalBest;

%% Results
kp = GlobalBest.Position(1);
ki = GlobalBest.Position(2);
kd = GlobalBest.Position(3);
%kp1 = GlobalBest.Position(4);
%ki1 = GlobalBest.Position(5);
%kd1 = GlobalBest.Position(6);
sim('prs_agc',[0 100]);
figure;
plot(BestCost,'LineWidth',2);
%semilogy(BestCost,'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;
