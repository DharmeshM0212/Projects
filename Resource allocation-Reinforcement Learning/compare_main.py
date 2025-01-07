import numpy as np
import matplotlib.pyplot as plt
from gym import Env, spaces
from stable_baselines3 import PPO

# Step 1: Define the RL Environment
class ResourceAllocationEnv(Env):
    def __init__(self, num_devices=20, total_bandwidth=100, total_power=50):
        super(ResourceAllocationEnv, self).__init__()
        
        # Parameters
        self.num_devices = num_devices
        self.total_bandwidth = total_bandwidth
        self.total_power = total_power
        
        # Action space: MultiDiscrete, allocate 0-10 Mbps to each device
        self.action_space = spaces.MultiDiscrete([11] * num_devices)
        
        # Observation space: Remaining resources, requests, and priorities
        self.observation_space = spaces.Box(
            low=0, high=1, shape=(2 + 3 * num_devices,), dtype=np.float32
        )
        
        # Initialize the state
        self.reset()

    def reset(self):
        # Reset the environment
        self.remaining_bandwidth = self.total_bandwidth
        self.remaining_power = self.total_power

        # Generate random requests and priorities
        self.bandwidth_requests = np.random.randint(1, 11, size=self.num_devices)
        self.power_requests = np.random.randint(1, 6, size=self.num_devices)
        self.priorities = np.random.randint(1, 4, size=self.num_devices)

        # Return the initial state
        return self._get_state()

    def _get_state(self):
        # Combine all state components into a single vector
        return np.concatenate((
            [self.remaining_bandwidth / self.total_bandwidth, 
             self.remaining_power / self.total_power],
            self.bandwidth_requests / self.total_bandwidth,
            self.power_requests / self.total_power,
            self.priorities / 3.0
        ))

    def step(self, action):
        # Allocate resources based on action
        allocated_bandwidth = np.minimum(action, self.bandwidth_requests)
        allocated_bandwidth = np.minimum(allocated_bandwidth, self.remaining_bandwidth)
        
        allocated_power = np.minimum(action, self.power_requests)
        allocated_power = np.minimum(allocated_power, self.remaining_power)
        
        # Update remaining resources
        self.remaining_bandwidth -= np.sum(allocated_bandwidth)
        self.remaining_power -= np.sum(allocated_power)
        
        # Calculate reward
        throughput = np.sum(allocated_bandwidth)
        unmet_demand = np.sum(self.bandwidth_requests) - throughput
        reward = throughput - unmet_demand
        
        # Check if episode is done
        done = self.remaining_bandwidth <= 0 or self.remaining_power <= 0
        
        # Return next state, reward, and done flag
        return self._get_state(), reward, done, {}

# Step 2: Train the RL Agent
# Create the environment
env = ResourceAllocationEnv()

# Create the PPO agent
model = PPO("MlpPolicy", env, verbose=1, learning_rate=0.001, gamma=0.99)

# Train the agent
print("Training the PPO agent...")
model.learn(total_timesteps=5000)
print("Training complete!")

# Step 3: Evaluate the Trained Agent
def evaluate_rl(env, model, episodes=10):
    throughput = []
    unmet_demand = []
    for ep in range(episodes):
        state = env.reset()
        done = False
        while not done:
            action, _ = model.predict(state, deterministic=True)
            state, _, done, _ = env.step(action)

            allocated_bandwidth = np.minimum(action, env.bandwidth_requests)
            throughput.append(np.sum(allocated_bandwidth))
            unmet_demand.append(np.sum(env.bandwidth_requests) - np.sum(allocated_bandwidth))
    return throughput, unmet_demand

rl_throughput, rl_unmet_demand = evaluate_rl(env, model)

# Step 4: Evaluate the Normal Priority Allocation
def evaluate_priority_allocation(num_devices=20, total_bandwidth=100, total_power=50, l=10):
    throughput = []
    unmet_demand = []
    dev_priorities = np.random.randint(1, 4, size=num_devices)
    
    for _ in range(l):
        bandwidth_requests = np.random.randint(1, 11, size=num_devices)
        power_requests = np.random.randint(1, 6, size=num_devices)

        allocated_bandwidth = np.zeros(num_devices)
        allocated_power = np.zeros(num_devices)

        remaining_bandwidth = total_bandwidth
        remaining_power = total_power

        priority_indices = np.argsort(dev_priorities)
        bandwidth_requests = bandwidth_requests[priority_indices]
        power_requests = power_requests[priority_indices]

        for i in range(num_devices):
            if bandwidth_requests[i] <= remaining_bandwidth and power_requests[i] <= remaining_power:
                allocated_bandwidth[i] = bandwidth_requests[i]
                allocated_power[i] = power_requests[i]
                remaining_bandwidth -= bandwidth_requests[i]
                remaining_power -= power_requests[i]
        throughput.append(np.sum(allocated_bandwidth))
        unmet_demand.append(np.sum(bandwidth_requests) - np.sum(allocated_bandwidth))
    return throughput, unmet_demand

priority_throughput, priority_unmet_demand = evaluate_priority_allocation()

# Step 5: Plot Results for Comparison
plt.figure(figsize=(14, 7))

# Throughput Comparison
plt.subplot(2, 1, 1)
plt.plot(range(len(rl_throughput)), rl_throughput, label='RL Throughput (Mbps)', linestyle='--', marker='o')
plt.plot(range(len(priority_throughput)), priority_throughput, label='Priority Throughput (Mbps)', linestyle='-', marker='x')
plt.title('Throughput Comparison')
plt.xlabel('Time Step')
plt.ylabel('Throughput (Mbps)')
plt.legend()
plt.grid()

# Unmet Demand Comparison
plt.subplot(2, 1, 2)
plt.plot(range(len(rl_unmet_demand)), rl_unmet_demand, label='RL Unmet Demand (Mbps)', linestyle='--', marker='o')
plt.plot(range(len(priority_unmet_demand)), priority_unmet_demand, label='Priority Unmet Demand (Mbps)', linestyle='-', marker='x')
plt.title('Unmet Demand Comparison')
plt.xlabel('Time Step')
plt.ylabel('Unmet Demand (Mbps)')
plt.legend()
plt.grid()

plt.tight_layout()
plt.show()
