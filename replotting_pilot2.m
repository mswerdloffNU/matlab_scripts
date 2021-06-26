sit = table2array(S00Xsitavgeq);
stand = table2array(S00Xstandavgeq);
walk = table2array(S00Xwalkavgeq);

figure
hold on
subplot(1,3,1)
plot([1:300],mean(sit,2),'-')
subplot(1,3,2)
plot([1:300],mean(stand,2),'-')
subplot(1,3,3)
plot([1:300],mean(walk,2),'-')

figure
hold on
plot([1:300],mean(sit,2),'-')
plot([1:300],mean(stand,2),'-')
plot([1:300],mean(walk,2),'-')
