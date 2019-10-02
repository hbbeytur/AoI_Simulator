arrRate = [0.1:0.1:1.5 2:2:10];
figure(1);
num_plots = size(tthrs,1);
for i = 1:num_plots
plot(1:13,tthrs(i,:))
hold on
end
legend('MAD-prmpt LCFS B=Inf, exponential','MAD-prmpt LCFS B=Inf, gamma','MAD-nonprmpt LCFS B=Inf, exponential','MAD-nonprmpt LCFS B=Inf, gamma')
%legend('MAD-prmpt LCFS B=Inf, exponential','MAD-prmpt LCFS B=Inf, gamma','MAD-nonprmpt LCFS B=Inf, exponential','MAD-nonprmpt LCFS B=Inf, gamma')
xlabel('service rate = # of flows')
title('MAD, traffic intensity=1')
% xlabel('arrival rate')
% title('# of flows = 1')
ylabel('average throughput over all flows')

hold off
grid on

figure(2);
for i = 1:num_plots
plot(1:13,taves(i,:))
hold on
end
legend('MAD-prmpt LCFS B=Inf, exponential','MAD-prmpt LCFS B=Inf, gamma','MAD-nonprmpt LCFS B=Inf, exponential','MAD-nonprmpt LCFS B=Inf, gamma')
%legend('nonprmpt LCFS B=Inf, exponential','nonprmpt LCFS B=Inf, gamma','prmpt LCFS B=Inf, exponential','prmpt LCFS B=Inf, gamma','MAD-prmpt LCFS B=Inf, exponential','MAD-prmpt LCFS B=Inf, gamma')
%legend('MAD-prmpt LCFS B=Inf, exponential','MAD-prmpt LCFS B=Inf, gamma','MAD-nonprmpt LCFS B=Inf, exponential','MAD-nonprmpt LCFS B=Inf, gamma')
xlabel('service rate = # of flows')
title('MAD, traffic intensity=10')
% xlabel('arrival rate')
% title('# of flows = 1')
ylabel('average age over all flows')
hold off
grid on