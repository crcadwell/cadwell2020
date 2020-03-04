diff2 = {};
for i = 1:9
    diff2{i} = diff{i} - mean(diff{i});
    p2(i) = (length(find(diff2{i}<=-abs(mean(diff{i}))))+length(find(diff2{i}>=abs(mean(diff{i})))))./length(diff2{i});
end

diff2_a = diff_a - mean(diff_a);
p2_a = (length(find(diff2_a<=-abs(mean(diff_a))))+length(find(diff2_a>=abs(mean(diff_a)))))./length(diff2_a);

diff2_b = diff_b - mean(diff_b);
p2_b = (length(find(diff2_b<=-abs(mean(diff_b))))+length(find(diff2_b>=abs(mean(diff_b)))))./length(diff2_b);

diff2_w = diff_w - mean(diff_w);
p2_w = (length(find(diff2_w<=-abs(mean(diff_w))))+length(find(diff2_w>=abs(mean(diff_w)))))./length(diff2_w);