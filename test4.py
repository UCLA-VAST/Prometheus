def calculate_latency(node, dependencies, latency, shifts, memo):
    if node in memo:
        return memo[node]
    
    if not dependencies[node]:  # If there are no dependencies
        memo[node] = latency[node]
        return latency[node]
    
    dependency_latencies = []
    for dep in dependencies[node]:
        dep_latency = calculate_latency(dep, dependencies, latency, shifts, memo)
        shift = shifts.get((dep, node), "0")
        dependency_latencies.append(f"{shift} + {latency[node]}, {dep_latency}")
    
    if dependency_latencies:
        max_dependency_latency = f"max({', '.join(dependency_latencies)})"
    else:
        max_dependency_latency = latency[node]
    
    total_latency = max_dependency_latency
    memo[node] = total_latency
    return total_latency

# Example usage
dependencies = {0: [], 1: [], 2: [], 3: [], 4: [0, 1], 5: [2, 3], 6: [5], 7: [4, 6]}
latency = {0: 'L0', 1: 'L1', 2: 'L2', 3: 'L3', 4: 'L4', 5: 'L5', 6: 'L6', 7: 'L7'}
shifts = {(0, 4): 'S0_4', (1, 4): 'S1_4', (2, 5): 'S2_5', (3, 5): 'S3_5', (5, 6): 'S5_6', (4, 7): 'S4_7', (6, 7): 'S6_7'}
memo = {}

# Calculate total latency for each node
total_latencies = {node: calculate_latency(node, dependencies, latency, shifts, memo) for node in dependencies}
for node, total_latency in total_latencies.items():
    print(f"Total latency for node {node}: {total_latency}")
