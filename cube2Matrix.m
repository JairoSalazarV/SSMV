function X = cube2Matrix(cube)
  [R,C,L] = size(cube);
  X       = zeros((R*C),L);
  i       = 1;
  for r=1:R
    for c=1:C
      X(i,:)  = squeeze(cube(r,c,:));
      i       = i + 1;
    end
  end
end