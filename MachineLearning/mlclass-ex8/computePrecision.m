function precision = computePrecision(yval, pval, epsilon)

	% e.g.
	% yval = [11001010]
	% anom = [01010110]
	%
	% tp =   [01000010]
	% tn =   [00100001]
	% fp =   [00010100]
	% fn =   [10001000]
	
	anomalies = pval < epsilon;
	tp = sum(yval & anomalies);
	fp = sum(anomalies) - tp;
	
	precision = tp / (tp+fp);
end