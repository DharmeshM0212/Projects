import numpy as np
import matplotlib.pyplot as plt


l=10
throughput=[]
unmet_demand=[]
num_devices = 20
total_bandwidth = 100  
total_power = 50   

dev_priorities=np.random.randint(1,4,size=num_devices)


for i in range(l):
    bandwidth_requests = np.random.randint(1, 11, size=num_devices)  
    power_requests = np.random.randint(1, 6, size=num_devices)       

    allocated_bandwidth = np.zeros(num_devices)
    allocated_power = np.zeros(num_devices)

    remaining_bandwidth = total_bandwidth
    remaining_power = total_power

    priority_indices=np.argsort(dev_priorities)
    bandwidth_requests=bandwidth_requests[priority_indices]
    power_requests=power_requests[priority_indices]

    for i in range(num_devices):
        if bandwidth_requests[i] <= remaining_bandwidth and power_requests[i] <= remaining_power:
            allocated_bandwidth[i] = bandwidth_requests[i]
            allocated_power[i] = power_requests[i]
            remaining_bandwidth -= bandwidth_requests[i]
            remaining_power -= power_requests[i]
    throughput.append(np.sum(allocated_bandwidth))
    unmet_demand.append(np.sum(bandwidth_requests) - np.sum(allocated_bandwidth))
plt.figure(figsize=(10, 5))
plt.plot(range(l), throughput, label='Throughput (Mbps)')
plt.plot(range(l), unmet_demand, label='Unmet Demand (Mbps)')
plt.xlabel('Time Step')
plt.ylabel('Bandwidth (Mbps)')
plt.title('Resource Allocation Over Time')
plt.legend()
plt.grid()
plt.show()
