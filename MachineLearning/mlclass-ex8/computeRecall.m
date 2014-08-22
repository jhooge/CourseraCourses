function recall = computeRecall(yval, pval, epsilon)
	
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
	fn = sum(yval & not(anomalies));
	
	recall = tp / (tp+ fn);
end