flow_a = arrT(1,(find(arrT(2,:)==1)));
flow_b = arrT(1,(find(arrT(2,:)~=1)));

figure;
hold on;
plot(flow_a,zeros(1,size(flow_a,2)),'k^');
plot(flow_b,zeros(1,size(flow_b,2)),'ko');

sent_flow_a = SarrT{1};
sent_flow_b = [];
for i = 2:size(SarrT,1), sent_flow_b = [sent_flow_b SarrT{i}]; end

plot(sent_flow_a,zeros(1,size(sent_flow_a,2)),'k^','MarkerFaceColor','red');
plot(sent_flow_b,zeros(1,size(sent_flow_b,2)),'ko','MarkerFaceColor','red');

received_flow_a = recT{1};
received_flow_b = [];
for i = 2:size(recT,1), received_flow_b = [received_flow_b recT{i}]; end

plot(received_flow_a,zeros(1,size(received_flow_a,2)),'kv','MarkerFaceColor','blue');
plot(received_flow_b,zeros(1,size(received_flow_b,2)),'ko','MarkerFaceColor','blue');

age_a = [0;0];
age_b = [0;0];

sent_flow_a = [0 sent_flow_a];
sent_flow_b = [0 sent_flow_b];

for i = 1:size(sent_flow_a,2)-1
    age_a = [age_a [received_flow_a(i)-sent_flow_a(i);received_flow_a(i)] [received_flow_a(i)-sent_flow_a(i+1);received_flow_a(i)]];
end
for i = 1:size(sent_flow_b,2)-1
    age_b = [age_b [received_flow_b(i)-sent_flow_b(i);received_flow_b(i)] [received_flow_b(i)-sent_flow_b(i+1);received_flow_b(i)]];
end

plot(age_a(2,:),age_a(1,:))
plot(age_b(2,:),age_b(1,:),'--k')