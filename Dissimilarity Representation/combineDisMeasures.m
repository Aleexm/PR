%% Creates a new dissimilarity matrix via a weighted average of two others
% perc1 = weight for first matrix
% perc2 = weight for second matrix
function [merge] = combineDisMeasures(perc1, perc2, mat1, mat2)
    merge = perc1 * mat1 * disnorm(mat1) + perc2 * mat2 * disnorm(mat2);
    merge = merge * disnorm(merge); % normalize final matrix also
end