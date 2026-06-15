# CONTEXT.md - EMPIRE OF RUINS (Working Title)

## GAME IDENTITY

A slow, single-player empire-builder where you enable growth rather than force it. Settlements grow when they're ready, not when you click a button. Unemployed people become beggars, thieves, bandits, revolutionaries, and enemy spies. Every playthrough is different due to procedural maps, random events, and starting scenarios.

**Core Fantasy:** Rebuild a fallen kingdom from a ruined fort to a sprawling empire. Control 12-15 villages, 3-5 towns, and 1-2 cities. Watch your economy climb. Paint the map. Survive internal collapse as much as external enemies.

**Key Influences:**
- AOE2 (map control, unit counters, city building)
- Manor Lords (economic feedback, specialization, organic growth)
- Songs of Syx (immigration, demographics, satisfaction, scale)
- RimWorld (random events, emergent stories, settlement quirks)
- Stardew Valley (seasons, chill pacing, no-lose state)
- Minecraft (random seeded maps, fog of war, exploration)
- Crusader Kings (different every playthrough, paint the map, internal management)

**Platform:** PC (Windows/Mac/Linux via Pygame)

**Target Playtime:** 10-20 hours per campaign (grow from 1 to 20 settlements)

---

## CORE GAMEPLAY LOOP

1. Start on a procedurally generated 50x50 map with fog of war. One ruined fort. 20 survivors.
2. Repair the well, build huts, clear farms. Manage housing, food, and unemployment.
3. Immigrants arrive based on pull factors (housing, food variety, safety, low taxes).
4. Expand by founding new settlements or conquering enemy ones.
5. Each settlement can specialize (fishing, mining, farming, lumber, trade, military).
6. Random events disrupt plans. Seasons change priorities.
7. Unemployed population escalates: Beggars → Thieves → Bandits → Revolutionaries → Enemy Spies.
8. Maintain loyalty through low taxes, garrisons, gifts, and protection.
9. Balance standing army (expensive, reliable) vs militia (free, unreliable, based on loyalty).
10. Paint the entire map your color by controlling all settlements.
11. New game with new seed and starting scenario.

---

## WORLD SIZE & SCALE

| Metric | Value |
|:---|:---|
| Map dimensions | 50x50 tiles (2,500 total) |
| Tile size | 32x32 pixels |
| Total settlements | 16-22 (12-15 villages, 3-5 towns, 1-2 cities) |
| Population per village | 50-200 |
| Population per town | 500-2,000 |
| Population per city | 3,000-8,000 |
| Total empire population | 5,000-29,000 |

---

## SETTLEMENT TIERS (ORGANIC GROWTH)

Settlements upgrade automatically when conditions are met. No manual upgrade button.

| Tier | Population | Requirements to Advance | Unlocks |
|:---|:---|:---|:---|
| Hamlet | 1-50 | None (starting tier) | Basic buildings (Hut, Woodcutter, Gatherer, Well) |
| Village | 50-200 | 200 pop, 90% housing, 20 food surplus, palisade, market | Specializations, farms, mines, docks |
| Town | 200-2,000 | 2,000 pop, 90% housing, 100 food surplus, stone wall, market square, chapel | Stone walls, barracks, guardhouse, advanced specialization |
| City | 2,000-8,000 | 8,000 pop, 90% housing, cathedral/castle/university, palace | Elite units, unique paths (military/economic/cultural) |

**Growth Check:** Run every season. One function. No player action required beyond enabling conditions.

---

## SETTLEMENT SPECIALIZATIONS

Each village can choose one specialization. Affects production, loyalty sensitivity, and unique buildings.

| Specialization | Produces | Unique Buildings | Loyalty Sensitivity |
|:---|:---|:---|:---|
| Fishing | Fish, oil | Smokehouse, Harbor | Medium (need protection from sea raiders) |
| Mining | Iron, coal, stone | Ore Crusher, Deep Shaft | Low (miners are tough) |
| Farming | Grain, vegetables, livestock | Windmill, Bakery, Cattle Pasture | High (attached to land) |
| Lumber | Wood, charcoal | Saw Pit, Carpentry Workshop | Low (transient workers) |
| Trade | Gold (tolls/trade) | Trading Post, Guild Hall | Medium (follow profit) |
| Military | Recruits, training | Training Ground, Archery Range, Stable | Very High (most loyal or most dangerous) |

---

## IMMIGRATION SYSTEM (STOLEN FROM SONGS OF SYX)

Immigration is controlled by pull factors, not player buttons.

| Pull Factor | Effect |
|:---|:---|
| Housing availability | +10 immigrants per empty house |
| Food variety | +5 per food type (grain, fish, meat, vegetables) |
| Job availability | +2 per empty job slot |
| Safety (walls + garrison) | +20 if walls exist, +10 if garrison present |
| Luxury goods | +5 per type (ale, jewelry, tools) |
| Low taxes | +15 if taxes <10%, -15 if >20% |

**Push Factors (cause emigration):**
- Overcrowding: -5 per 10 people over housing capacity
- Hunger: -50 if food storage empty
- War: -30 if recently raided
- High taxes: -20 if taxes >20%

---

## UNEMPLOYMENT THREAT CHAIN

Unemployed population becomes progressively worse threats. Each stage escalates if unemployment continues rising.

| Unemployment Rate | Threat | Mechanical Effect |
|:---|:---|:---|
| 5-10% | Beggars | -5% tax income, -2 happiness |
| 10-15% | Thieves | -10% tax income, -5 happiness, random theft of 5-20 gold/season |
| 15-25% | Bandits | Bandit camps spawn on map, -30% trade income, caravans raided |
| 25-35% | Revolutionaries | Loyalty drops 1-5/season, random sabotage, militia may refuse orders |
| 35%+ | Enemy Spies | Enemy knows troop positions, garrisons poisoned, settlement may flip without combat |

**Solution Tools:** Build Poorhouse (Town), Guardhouse (Town), destroy bandit camps, lower taxes, create jobs, Courthouse (City), Spymaster's Guild (City).

---

## LOYALTY SYSTEM

0-100 scale. Affects taxes, militia reliability, revolt risk.

| Score | Effect |
|:---|:---|
| 80-100 | Full taxes, militia full strength, warn of attacks |
| 60-79 | Normal operation |
| 40-59 | -25% tax income, militia 75% strength, may refuse conscription |
| 20-39 | Revolt risk, militia fights for enemy, -50% tax income |
| 0-19 | Active rebellion, declares independence or joins enemy |

**Loyalty Factors:**
- Positive: Low taxes, protection (garrison), food surplus, cultural/religious alignment, local autonomy, gifts/investments, victory celebrations
- Negative: High taxes, frequent raids, food shortage, appointed outsider governor, forced conscription, defeats in war

**Decay:** -2 per season with no player interaction. -5 per season with high taxes (>15%). -10 per season with conscription active.

---

## MILITARY SYSTEM

### Standing Army
- Stationed in cities and major towns only
- High cost (gold per unit per season)
- 100% reliable
- Professional stats (better than militia)
- Can be renamed (e.g., "Royal Spearmen of Riverfall")

### Militia
- Source: Villages (10-50 per village based on population)
- Free to raise, but workers stop producing (economic loss)
- Reliability based on village loyalty (see loyalty table)
- Poor quality (basic weapons, low morale)
- Can be renamed (e.g., "Riverfall Fishing Militia")
- Cannot leave home region for long

### Unit Counters (AOE2-style)
| Unit | Strong vs | Weak vs |
|:---|:---|:---|
| Spearman | Cavalry | Archer |
| Archer | Spearman | Cavalry |
| Cavalry | Archer | Spearman |

### Combat Resolution
- No real-time micro. Send units, watch log.
- Auto-resolve based on unit types, numbers, and loyalty.

---

## GARRISON SYSTEM

Station standing army units in any settlement as garrison.

| Garrison Size | Loyalty Effect | Cost/Season |
|:---|:---|:---|
| Symbolic (5 units) | +5 | Low |
| Small (20 units) | +15 | Medium |
| Large (50 units) | +30 | High |
| Oppressive (100+ units) | +50 but -20 happiness | Very High |

**Trade-off:** Large garrisons force loyalty but breed resentment. Small garrisons build genuine loyalty over time.

---

## BUILDING TREE

### Hamlet (1-50 pop)
| Building | Cost | Effect |
|:---|:---|:---|
| Hut | 5 wood | Houses 5 families |
| Woodcutter | 10 wood | Produces 5 wood/season |
| Gatherer's Hut | 5 wood | Produces 3 berries/season |
| Well | 5 stone | +5 happiness, enables farming |
| Dirt Path | 1 wood/tile | +10% efficiency |

### Village (50-200 pop)
| Building | Cost | Effect |
|:---|:---|:---|
| Farm | 20 wood | Produces 15 grain/season |
| Granary | 15 wood | Food storage (100→500) |
| Stockpile | 10 wood | Resource storage |
| Market Stall | 10 wood | +5 gold/season |
| Wooden Palisade | 50 wood | Basic defense, +10 loyalty |
| Specialization buildings | Varies | See specialization table |

### Town (200-2,000 pop)
| Building | Cost | Effect |
|:---|:---|:---|
| Stone Wall (upgrade) | 200 stone | Strong defense, +20 loyalty |
| Market Square | 100w/50s | +25 gold/season |
| Barracks | 150w/50s | Train standing army |
| Guardhouse | 100 wood | Holds 20 garrison (free upkeep) |
| Chapel | 100 stone | +10 happiness, +5 loyalty |
| Inn | 80 wood | +15 gold/season, attracts traders |
| Stone Road | 2 stone/tile | +20% efficiency, faster troops |

### City (2,000-8,000 pop)
| Building | Cost | Effect |
|:---|:---|:---|
| Cathedral | 500s/200w/100g | +30 happiness, +20 loyalty |
| Castle | 800s/300w | Super defense, holds 100 garrison, elite units |
| University | 400s/200w | Unlocks technology research |
| Palace | 600s/300w/200g | +20% tax income from all settlements |
| Great Market | 300w/200s | +100 gold/season |
| Aqueduct | 400 stone | +20% population growth, +10 happiness |
| Arena | 300s/150w | +15 happiness, trains champions |

---

## HINDRANCES (WHAT PREVENTS INFINITE GROWTH)

| Hindrance | Effect |
|:---|:---|
| **Upkeep Costs** | Every building costs gold/wood/stone per season. Cathedral costs 15 gold, 5 stone. |
| **Diminishing Returns** | 2nd farm produces 20% less, 3rd 40% less, 4th 60% less. Forces expansion. |
| **Caravan Bottlenecks** | Dirt path capacity: 10 carts/season. Stone road: 30. Highway: 100. Exceeding capacity causes delays and spoilage. |
| **Loyalty Decay** | -2 loyalty/season with no interaction. -5 if high taxes. |
| **Random Disasters** | Fire, flood, plague, blight, mine collapse. 5-10% chance per season. |
| **Enemy Pressure** | Enemy AI expands, builds settlements, attacks weak points. |
| **Resource Depletion** | Iron veins (500-2000 ore). Stone quarries (300-1000). Deplete with use. |
| **Noble/Elite Demands** | Merchants, nobility, clergy, military factions make demands. Ignoring causes penalties. |

---

## SEASONS

| Season | Feeling | Modifiers | Player Priority |
|:---|:---|:---|:---|
| **Spring** | Hope | +25% farming, +50% immigration, +20% building speed, -50% bandits | Plant farms, expand, repair |
| **Summer** | Danger | +50% farming (early harvest), +100% bandits, +50% enemy attacks, +25% disease | Early harvest, military campaigns, destroy bandits |
| **Autumn** | Urgency | +100% farming (main harvest), +200% bandits, +100% enemy attacks, +50% trade, -20% building | Main harvest, stockpile, final battles |
| **Winter** | Survival | 0% farming, -75% fishing, -90% trade, +200% wood consumption, +20% food consumption | Survive, plan, upgrade indoors, diplomacy |

**Seasonal Events:** Floods, heat waves, blizzards, famine, refugee waves, child booms, religious revivals.

---

## STARTING SCENARIOS

| Scenario | Location | Resources | Challenge | Difficulty |
|:---|:---|:---|:---|:---|
| Ruined Fort (default) | Inland | Balanced | Wolves, food shortage | Normal |
| Coastal Ruins | Coast | More wood, less stone | Sea raiders in year 2 | Easy |
| Mountain Outpost | Hills | More stone, iron exposed | Poor soil, less food | Hard |
| Forest Refuge | Deep forest | Abundant wood | More bandits | Medium |
| Trade Post Ruins | River crossing | Starts with damaged Trading Post | Enemy scouts early | Hard |
| Abandoned Monastery | Hills | Starts with damaged Chapel | Religious faction demands | Medium |
| Nothing (Hard Mode) | Random | Half resources, no ruins | Everything harder | Very Hard |

---

## STARTING RESOURCES (Ruined Fort default)

| Resource | Amount |
|:---|:---|
| Wood | 15 |
| Stone | 8 |
| Food | 40 |
| Gold | 0 |
| Population | 20 |

**Starting Tile:** Ruined Fort (collapsed walls, burned barracks, filled well). Provides salvageable resources.

---

## ARCHITECTURE & TECH STACK

| Component | Choice |
|:---|:---|
| Language | Python 3 |
| Game Library | Pygame |
| Data Format | JSON (all game data in JSON files) |
| Save Format | JSON (entire game state in one file) |
| Version Control | Git |

**Project Structure:**