% QLDC Quadratic/Linear classifier 
% 
%   [C,E,P] = qldc(T,D,L,type)
%
% INPUT 
%   T        Test dataset matrix to be classified
%   D        Training dataset matrix (without labels column)
%   L        Labels vector 
%   type     'quadratic','diagQuadratic','linear','diagLinear' (default: 'quadratic')
%
% OUTPUT
%   C        Crisp class labels (by MAP rule)  
%   E        Apparent error over the training set (as fraction)
%   P        Posterior probabilities (n x k matrix)
%
% DESCRIPTION
% Implements a quadratic or linear (normal-based) classifier and returns the 
% soft (posterior) labels and crisp labels using the MAP rule.

% Jimmy Azar, jimmy.azar@gmail.com
% qldc.m, 2016/04/04


function [C,E,P] = qldc(T,D,L,type)

if nargin < 4 | isempty(type)
    type = 'quadratic';
    warning('type = ''quadratic''');
end

if nargin < 3 | isempty(L)
    warning('Label vector not specified!');
    return
end

if nargin < 2 | isempty(D)
    warning('Training data matrix not specified!');
    return
end

if nargin < 1 | isempty(T)
    warning('Test data matrix not specified!');
    return
end

obj = ClassificationDiscriminant.fit(D,L,'discrimType',type);  %classifier object
[C,E,P] = classify(T,D,L,type);

end
