function [X] = z_transform(X)
%SELECTTHRESHOLD Find the best threshold (epsilon) to use for selecting
%outliers
%   [bestEpsilon bestF1] = SELECTTHRESHOLD(yval, pval) finds the best
%   threshold to use for selecting outliers based on the results from a
%   validation set (pval) and the ground truth (yval).
%
[n,m] = size(X);

for i = 1:n
	i
	X(i,:) = (X(i,:)-mean(X(i,:)))/std(X(i,:))
end
