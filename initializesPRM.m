function qTraj = initializesPRM(rob,prmNumSamples, prmRadius,sphere1Center,sphere1Radius, qStart, qGoal, qMax, qMin)



samples = rand(prmNumSamples,6) .* repmat(qMax - qMin,[prmNumSamples 1]) + repmat(qMin,[prmNumSamples 1]);
samples(1,:) = qStart;
samples(2,:) = qGoal;
% Prune collision samples and get weighted adjacency matrix for
% r-disk graph.
[samplesFree, adjacencyMat] = sPRM(rob,samples,prmRadius,sphere1Center,sphere1Radius);

% Create matlab graph object
G = graph(adjacencyMat);

% Display number of connected components
numComponents = size(unique(conncomp(G)),2);
%display(sprintf('number of connected components: %d',numComponents));

% Find shortest path
[path, pathLength] = shortestpath(G,1,2);
%display(sprintf('path length: %f',pathLength));
qMilestones = samplesFree(path,:);
qTraj = interpMilestones(qMilestones);

if pathLength == Inf
    qTraj = [];
    error('No path found!')
end
qTraj;
end








    