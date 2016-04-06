function [ projectedPt ] = projectPts( ptoffPlane,ptonPlane,plane )
% plane variable comes in [normal,d]
proj = [];
for i = 1:length(ptoffPlane(:,1))
    normal = plane(1:3);
    proj = [proj; ptoffPlane(i) - dot(ptoffPlane(i)-ptonPlane,normal)*normal];
end
projectedPt = proj;
end

