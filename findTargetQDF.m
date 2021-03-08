function T = findTargetQDF(x, u, segma)
d = sqrt((x-u)*pinv(segma)*(x-u)');
rou = 50;
T = u + (x-u)*min(1,rou/d);
end