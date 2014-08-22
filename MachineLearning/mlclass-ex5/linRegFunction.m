function [J, grad] = linearRegFunction(X, y, theta)
%LINEARREGFUNCTION Compute cost and gradient for regularized linear 
%regression with multiple variables


% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;