function X = matrix2Cube(matrix, R, C, L)
  X       = zeros(R,C,L);
  i       = 1;
  for r=1:R
    for c=1:C
      X(r,c,:)  = squeeze(matrix(i,:));
      i         = i + 1;
    end
  end
end