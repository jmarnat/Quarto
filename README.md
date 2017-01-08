# Quarto


## How to play :
The goal is to align 4 pieces with the same characteristics :

* color (`white`|`black`)
* height (`short`|`long`)
* geometry (`round`|`square`)
* hole (`hole`|`flat`)

The game follow this order :

1. You choose a piece to give to your adversary;
2. He put it on the board;
3. He gives you a piece, and so on...

## Run :
1. Run prolog using swipl or whatever,
2. Just load the main file by typing `consult('main.pl')`.
3. Then play by typing `play(Interface,Heuristics1,Heuristics2)` with:
	* `Interface` among:
		* `inline`
		* `silent` (for testing only)
		* `gui`
	* `Heuristics` among:
		* `human`
		* `random`
		* `ai_antho`
		* `josselin`
		* `clement`
		* `jeremie`
4. To display the board graphically, you need to have XQuartz installed first (MacOS).

## To-do list :
* Interfaces :
	- [x] inline
	- [x] GUI : display
	- [ ] GUI : interactions
* Heuristics :
	* [x] human
	* [x] random
	* [x] anthony
	* [x] clement
	* [x] jeremie
	* [x] josselin
