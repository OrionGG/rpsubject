function [ output_args ] = Practise2( input_args )
%PRACTISE2 Summary of this function goes here
%   Detailed explanation goes here
X = [2 4 3; 4 5 6; 2 5 6; 3 5 8; 4 3 2; 7 4 1;];
y = [1;1;2;2;3;3];

A = LDA(X,y);

A

end

