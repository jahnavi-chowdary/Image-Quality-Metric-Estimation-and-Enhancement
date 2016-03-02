addpath('./libsvm-3.20/matlab');

SPECTF = training_full;
labels = SPECTF(:,1);
features = SPECTF(:,2:end);
features_sparse = sparse(features);
libsvmwrite('SPECTFlibsvm.train',labels,features_sparse);