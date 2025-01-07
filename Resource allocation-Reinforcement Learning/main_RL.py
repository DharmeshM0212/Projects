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
episodes = 10  # Number of episodes for evaluation
throughput = []
unmet_demand = []
episode_rewards = []

for ep in range(episodes):
    state = env.reset()
    done = False
    total_reward = 0
    episode_throughput = []
    episode_unmet_demand = []

    while not done:
        # Predict action using the trained model
        action, _ = model.predict(state, deterministic=True)
        state, reward, done, _ = env.step(action)
        total_reward += reward

        # Track throughput and unmet demand
        allocated_bandwidth = np.minimum(action, env.bandwidth_requests)
        episode_throughput.append(np.sum(allocated_bandwidth))
        episode_unmet_demand.append(np.sum(env.bandwidth_requests) - np.sum(allocated_bandwidth))

    # Store results for the episode
    throughput.extend(episode_throughput)
    unmet_demand.extend(episode_unmet_demand)
    episode_rewards.append(total_reward)

# Print the average total reward
print(f"Average Total Reward per Episode: {np.mean(episode_rewards)}")

# Step 4: Visualize Results
plt.figure(figsize=(10, 5))
plt.plot(range(len(throughput)), throughput, label='Throughput (Mbps)')
plt.plot(range(len(unmet_demand)), unmet_demand, label='Unmet Demand (Mbps)')
plt.xlabel('Time Step')
plt.ylabel('Bandwidth (Mbps)')
plt.title('RL-Based Resource Allocation Performance')
plt.legend()
plt.grid()
plt.show()
