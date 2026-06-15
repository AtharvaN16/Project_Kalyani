import sys
from engine.simulation import SimulationEngine
from engine.constants import *

def run_headless_simulation(turns=4):
    """Runs the simulation without graphics for testing purposes."""
    engine = SimulationEngine("data/initial_state.json")
    
    for _ in range(turns):
        engine.process_turn()
        
    engine.save_state("data/latest_state.json")
    print("\nSimulation complete. Latest state saved to data/latest_state.json")

def main():
    print("Welcome to Empire of Ruins")
    
    # For now, we run a headless simulation to verify the engine
    run_headless_simulation()

if __name__ == "__main__":
    main()
