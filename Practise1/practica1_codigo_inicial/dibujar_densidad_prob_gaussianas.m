
function dibujar_densidad_prob_gaussianas(D, COLORES, GAUSSIANAS)
%
% GAUSSIANAS, es un cell-array con los parámetros de las gaussianas 
%             que representan a las diferentes clases.
%

[jj, ii] = meshgrid(1:D, 1:D);
X        = [ii(:) jj(:)];

X_class_cond    = zeros(size(X,1), length(GAUSSIANAS));  
class_posterior = zeros(size(X,1), length(GAUSSIANAS));  
for j=1:length(GAUSSIANAS)
  % mvnpdf calcula la función de densidad de una gausiana multidimensional
  % (media, Matriz Covarianzas)
  GAUSSIANAS{j}.cov
  X_class_cond(:,j)    = mvnpdf(X, GAUSSIANAS{j}.media(:)', GAUSSIANAS{j}.cov);
  class_posterior(:,j) = X_class_cond(:,j) .* GAUSSIANAS{j}.apriori;
end

p_x = sum(class_posterior, 2);

for i=1:length(X)
  class_posterior(i,:) = class_posterior(i,:) ./ p_x(i);
end

for j=1:length(GAUSSIANAS)
  hSurface = surf(vec2mat(X(:,2), D, D), vec2mat(X(:,1), D, D), vec2mat(X_class_cond(:,j), D, D));
  color    = COLORES{j};
  r        = color(1)/255;
  g        = color(2)/255;
  b        = color(3)/255;
  set(hSurface,'FaceColor',[r, g, b],'FaceAlpha',0.5);
  hold on;
end
xlabel('X');
ylabel('Y');




