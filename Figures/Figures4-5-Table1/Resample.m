dtype1 = 'tang_dist';
dtype2 = 'vert_dist';
diff1 = 20;
diff2 = 20;

minctl = 1;
nsamples = 1000;

%Find matched controls for each related pair

for m= 1:9
    Count = 0;
    if m==1
        ConnType = '23-23';
        s_data = s23s23; 
        c_data = ctl23ctl23;
    elseif m==2
        ConnType = '23-4';
        s_data = s23s4; 
        c_data = ctl23ctl4;
    elseif m==3
        ConnType = '23-5';
        s_data = s23s5; 
        c_data = ctl23ctl5;
    elseif m==4
        ConnType = '4-23';
        s_data = s4s23; 
        c_data = ctl4ctl23;    
    elseif m==5
        ConnType = '4-4';
        s_data = s4s4; 
        c_data = ctl4ctl4;    
    elseif m==6
        ConnType = '4-5';
        s_data = s4s5; 
        c_data = ctl4ctl5;    
    elseif m==7
        ConnType = '5-23';
        s_data = s5s23; 
        c_data = ctl5ctl23;    
    elseif m==8
        ConnType = '5-4';
        s_data = s5s4; 
        c_data = ctl5ctl4;    
    elseif m==9
        ConnType = '5-5';
        s_data = s5s5; 
        c_data = ctl5ctl5;    
    end
    for i = 1:length(s_data)
        dist1 = fetchn(mc.Distances & s_data(i),dtype1);
        dist2 = fetchn(mc.Distances & s_data(i),dtype2);
        if ~(dist1>=0) || ~(dist2>=0)
            continue            
        end
        set = fetch(mc.Distances & c_data & [dtype1 '>' num2str(dist1-diff1)] & [dtype1 '<' num2str(dist1+diff1)] & [dtype2 '>' num2str(dist2-diff2)] & [dtype2 '<' num2str(dist2+diff2)]);
        if size(set,1)>=minctl
            Count = Count + 1;
            re_s{m}(Count) = s_data(i);
            re_ctl{m}{Count} = set;
        end
    end
    re_mat{m} = randi(length(re_s{m}),length(re_s{m}),nsamples);
    for i = 1:nsamples
        conns = 0;
        connc = 0;
        for j = 1: length(re_s{m})
            if strcmp(fetchn(mc.Connections & re_s{m}(re_mat{m}(j,i)),'conn'),'connected')
                conns = conns + 1;
            end
            a = re_ctl{m}{re_mat{m}(j,i)};
            rc{m}(j,i) = a(randi(length(a)));
            if strcmp(fetchn(mc.Connections & rc{m}(j,i),'conn'),'connected')
                connc = connc + 1;
            end
        end            
        rs_mean{m}(i) = conns./length(re_s{m});
        rc_mean{m}(i) = connc./length(re_s{m});
    end
    diff{m} = rs_mean{m} - rc_mean{m};
end
    
