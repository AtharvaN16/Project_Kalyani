import json
from .constants import *

class SimulationEngine:
    def __init__(self, initial_state_path):
        with open(initial_state_path, 'r') as f:
            self.state = json.load(f)
        
        self.turn = self.state.get("turn", 1)
        self.season = self.state.get("season", "Spring")
        self.global_resources = self.state.get("global_resources", {"gold": 0})
        self.settlements = self.state.get("settlements", [])

    def process_turn(self):
        """Processes one turn (one season) of the simulation."""
        print(f"--- Processing Turn {self.turn} ({self.season}) ---")
        
        for settlement in self.settlements:
            self._process_settlement(settlement)
            
        # Advance turn and season
        self.turn += 1
        self._advance_season()
        
    def _process_settlement(self, settlement):
        """Internal logic for a single settlement's seasonal update."""
        name = settlement["name"]
        pop = settlement["population"]
        res = settlement["resources"]
        
        # 1. Food Consumption
        # Basic rule: 1 food per 5 people (abstracted from context)
        food_needed = pop["total"] // 5
        if res["food"] >= food_needed:
            res["food"] -= food_needed
            print(f"[{name}] Consumed {food_needed} food. Remaining: {res['food']}")
        else:
            # Hunger push factor
            deficit = food_needed - res["food"]
            res["food"] = 0
            print(f"[{name}] STARVATION! Deficit of {deficit} food.")
            # TODO: Implement emigration/loyalty drop from context
            
        # 2. Unemployment Check
        pop["unemployed"] = pop["total"] - pop["employed"]
        unemployment_rate = (pop["unemployed"] / pop["total"]) * 100
        print(f"[{name}] Unemployment Rate: {unemployment_rate:.1f}%")
        
        # 3. TODO: Organic Growth Check
        # 4. TODO: Random Events

    def _advance_season(self):
        seasons = ["Spring", "Summer", "Autumn", "Winter"]
        current_idx = seasons.index(self.season)
        self.season = seasons[(current_idx + 1) % len(seasons)]

    def save_state(self, path):
        output = {
            "turn": self.turn,
            "season": self.season,
            "global_resources": self.global_resources,
            "settlements": self.settlements
        }
        with open(path, 'w') as f:
            json.dump(output, f, indent=2)
