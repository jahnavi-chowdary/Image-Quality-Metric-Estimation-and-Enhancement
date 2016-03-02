close all;
clc;

tmp_lbl = l';
trn_lbl = l';
trn_ftr = finalvect_train;

% TRAIN
bestcv = 0;
for log2c = -5:5,
  for log2g = -5:5,
      l1 = sum(tmp_lbl == 0); l2 = sum(tmp_lbl == 1);
      w1 = 100*(l2/(l1+l2));  w2 = 100*(l1/(l1+l2));

      cmd = ['-q -s 2 -v 10 -c ', num2str(10^log2c) ' -w-1 '  num2str(w1) ' -w1 ' num2str(w2)];
%     cmd = ['-t 2 -v 5 -c ', num2str(10^log2c), ' -g ', num2str(10^log2g)];
    cv = svmtrain(trn_ftr,trn_lbl, cmd);
%         cv = svmtrain(trn_ftr,trn_lbl, cmd);
        if (cv >= bestcv),
      bestcv = cv; bestc = 10^log2c; bestg = 10^log2g;
    end
 
  end
end

clc
  fprintf('(best c=%g, g=%g, rate=%g)\n', bestc, bestg, bestcv);

%  cmd = ['-t 2 -c ', num2str(bestc), ' -g ', num2str(bestg)];
l1 = sum(tmp_lbl == -1); l2 = sum(tmp_lbl == 1);
w1 = 100*(l2/(l1+l2));  w2 = 100*(l1/(l1+l2));

cmd = ['-q -s 2 -v 10 -c ', num2str(10^log2c) ' -w-1 '  num2str(w1) ' -w1 ' num2str(w2)];
 model = svmtrain(trn_lbl,trn_ftr, cmd);

 
% TEST

[predict_lbl, accuracy, dec_val] = svmpredict(tst_lbl, tst_ftr, model);


% CLASS IMBALANCE

% l1 = sum(tmp_lbl == -1); l2 = sum(tmp_lbl == 1);
% w1 = 100*(l2/(l1+l2));  w2 = 100*(l1/(l1+l2));
% 
% cmd = ['-q -s 2 -v 10 -c ', num2str(10^log2c) ' -w-1 '  num2str(w1) ' -w1 ' num2str(w2)];