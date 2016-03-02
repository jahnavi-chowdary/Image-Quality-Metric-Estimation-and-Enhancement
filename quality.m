clc;
close all;

c = Dmed('../DMED');
id = c.getNumOfImgs;
q = [];
% Sort and take top 30 and bottom 30 without considering range
for i = 1 : id
    q(i) = c.getQuality(c.idMap(i));
end

[q_sort id_sort] = sort(q);
q_new = [q_sort(1:30),q_sort(140:169)]';
id_new = [id_sort(1:30),id_sort(140:169)]';
l(1:30,1) = 0;
l(31:60,1) = 1;
 im = c.getImg(id_new(1));
