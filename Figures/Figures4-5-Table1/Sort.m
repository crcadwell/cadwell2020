
clear all; close all

age = 22;
tx = 'E10.5';

conn = fetch(mc.Connections*mc.Experiments & ['age<=' num2str(age)] & ['tx_time="' tx '"']);

groupR = cell(3,3);
groupU = cell(3,3);
layers = {'2/3' '4' '5'};

for i = 1:length(conn)
    pre = fetch(mc.PatchCells & conn(i) & ['p_cell_id="' conn(i).cell_pre '"'],'*');
    post = fetch(mc.PatchCells & conn(i) & ['p_cell_id="' conn(i).cell_post '"'],'*');
    type = [find(strcmp(pre.layer,layers)) find(strcmp(post.layer,layers))];
    if ~strcmp(pre.type,'excitatory') || ~strcmp(post.type,'excitatory')
        continue
    end
    if ~strcmp(pre.fp,'pyramidal') && ~strcmp(pre.morph,'pyramidal')
        continue
    end
    if ~strcmp(post.fp,'pyramidal') && ~strcmp(post.morph,'pyramidal')
        continue
    end
    if strcmp(pre.label,'positive') && strcmp(post.label,'positive')
        groupR{type(1),type(2)} = [groupR{type(1),type(2)} conn(i)];
    elseif (strcmp(pre.label,'positive') && strcmp(post.label,'negative')) || (strcmp(pre.label,'negative') && strcmp(post.label,'positive'))
        groupU{type(1),type(2)} = [groupU{type(1),type(2)} conn(i)];
    end
end

