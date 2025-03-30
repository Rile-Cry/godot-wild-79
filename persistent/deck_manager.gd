extends Node

signal added_bonus(bonus: Genum.BonusType, level: Genum.BonusLevel)
signal bonus_level_up(new_level:Genum.BonusLevel)
signal card_collected(card:CardResource)

var card_resources : Dictionary[int, CardResource]
var deck_path : StringName = "res://mechanics/cards/"
var current_deck : Array[int]
var bonus_tracking : Dictionary[Genum.BonusType,Genum.BonusLevel]
var odd_counter = 0
var even_counter = 0
var seven_counter = 0
var sevens = false

func _ready() -> void:
	_load_cards()
	_initialize_bonuses()
	MapManager.generate_current_map()

func _initialize_bonuses():
	bonus_tracking[Genum.BonusType.EVN] = Genum.BonusLevel.ZERO
	bonus_tracking[Genum.BonusType.ODD] = Genum.BonusLevel.ZERO

func _load_cards() -> void:
	var dir_list := ResourceLoader.list_directory(deck_path)
	for res in dir_list:
		var card_res := ResourceLoader.load(deck_path + res) as CardResource
		card_resources.set(card_res.card_id, card_res)
	card_resources.sort()

# TODO: Write up the effects for the different cards.
# Also be able to handle score additions based on what's been collected.

func card_action() -> void:
	var current_card_id : int = MapManager.get_current_position_value()
	var current_card : CardResource = card_resources.get(current_card_id)
	print (current_card_id)
	if current_card_id == 11:
		SoundManager.play_sound(Sounds.sfx_pull_lost, "SFX")
		Global.set_var(Genum.Vars.PULLS, -1, true)
	elif current_card_id == 9:
		SoundManager.play_sound(Sounds.sfx_pull_added, "SFX")
		Global.set_var(Genum.Vars.PULLS, 2, true)
	
	if current_card.card_type == Genum.CardType.NUMBER:
		Global.set_var(Genum.Vars.SCORE, current_card_id + 1, true)
		if current_card_id % 2 == 0:
			odd_counter += 1
			even_counter = 0
		elif current_card_id % 2 == 1:
			even_counter += 1
			odd_counter = 0
		if current_card_id == 6:
			seven_counter += 1
	elif current_card.card_type == Genum.CardType.EFFECT:
		odd_counter = 0
		even_counter = 0
		seven_counter = 0
		match(current_card.card_name):
			"Treasure":
				Global.set_var(Genum.Vars.SCORE, 100, true)
			"Multiplier":
				var score = Global.get_var(Genum.Vars.SCORE)
				Global.set_var(Genum.Vars.SCORE, score * 2)
			"Bomb":
				Global.set_var(Genum.Vars.SCORE, -50, true)
				
	if current_card_id != 6:
		seven_counter = 0
	
	_add_to_deck(current_card)
	

	
	card_collected.emit(current_card)
	
	Global.set_var(Genum.Vars.PULLS, -1, true)

func _add_to_deck(card_to_add:CardResource) -> void:
	
	current_deck.append(card_to_add.card_id)
	
	if current_deck.size() > 2 : _bonus_check()

## TODO: Finish the remaining bonus pattern checking
## Below is the list of patterns to check for with our bonus checker
#	ABC - LvMAX - DONE
#	XYZ - LvMAX - DONE
#	ALPHABET - LvlMAX
#	ODD - Lv1, Lv2, LvlMAX
#	EVN - Lv1, Lv2, LvlMAX - DONE
#	EVEN THE ODDS - LvlMAX
#	LCK-A - Lvl1 - TBaT
#	LCK-B - Lvl1 - TNUMT
#	LCK - LvlMAX - TTT
#	BARTENDER - LvlMAX - BaBaBa
#	OOF - LvlMAX - BoBoBo
#	777 - Lvl1, Lvl2, LvlMAX
#	BONUS - LvlMAX 777 on max triggers
func _bonus_check() -> void:
	var card_chain = [
		current_deck[current_deck.size() - 3],
		current_deck[current_deck.size() - 2],
		current_deck[current_deck.size() - 1],
	]

	#TEMPLATE CHECK
	#if card_chain[0] == 1 and card_chain[0] == 2 and card_chain[2] == 3 :
		#print(bonus_tracking.get(Genum.BonusType.ABC))
		#if bonus_tracking.get(Genum.BonusType.ABC) == false or bonus_tracking.get(Genum.BonusType.ABC).value() < 2:
			#bonus_tracking.get_or_add(Genum.BonusType)
		#elif bonus_tracking.get(Genum.BonusType.ABC) == 3 :
			#print("Max Achieved, passing") 
			
	## ABC - DONE
	print("card chain: ", card_chain)
	if card_chain == [0, 1, 2] or card_chain == [2, 1, 0]:
		bonus_tracking[Genum.BonusType.ABC] = Genum.BonusLevel.ONE
		added_bonus.emit(Genum.BonusType.ABC,Genum.BonusLevel.ONE)
	## XYZ - DONE
	if card_chain == [5, 4, 3] or card_chain == [3, 4, 5]:
		bonus_tracking[Genum.BonusType.XYZ] = Genum.BonusLevel.ONE
		added_bonus.emit(Genum.BonusType.XYZ,Genum.BonusLevel.ONE)
	
	else:
		pass
		
	## NUMBERS
	if card_chain[0] < 9 :
		var even := true
		var odd := true
		sevens = false
		
		for card in card_chain:
			## ODD offset because the #1 card is at location 0, i.e. #1 == 0, #3 == 2, e etc
			var temp = card + 1
			if temp % 2 == 1 :
				even = false
				if temp % 7 == 0: sevens = true
				else : sevens = false
			elif temp % 2 == 0:
				odd = false
				sevens = false
				
		if Global.debug_active : print(str(sevens) + " and sevens counter: " + str(seven_counter))
		
		if even and even_counter % 3 == 0:
			match bonus_tracking[Genum.BonusType.EVN]:
				Genum.BonusLevel.ZERO:
					bonus_tracking[Genum.BonusType.EVN] = Genum.BonusLevel.ONE
					added_bonus.emit(Genum.BonusType.EVN,Genum.BonusLevel.ONE)
				Genum.BonusLevel.ONE:
					bonus_tracking[Genum.BonusType.EVN] = Genum.BonusLevel.TWO
					GameGlobalEvents.level_up.emit(Genum.BonusType.EVN,Genum.BonusLevel.TWO)
				Genum.BonusLevel.TWO:
					bonus_tracking[Genum.BonusType.EVN] = Genum.BonusLevel.MAX
					GameGlobalEvents.level_up.emit(Genum.BonusType.EVN,Genum.BonusLevel.MAX)
				Genum.BonusLevel.MAX:
					print("Max level, no upgrade possible")
			
		## EVN - DONE
		if odd and odd_counter % 3 == 0:
			match bonus_tracking[Genum.BonusType.ODD]:
				Genum.BonusLevel.ZERO:
					bonus_tracking[Genum.BonusType.ODD] = Genum.BonusLevel.ONE
					added_bonus.emit(Genum.BonusType.ODD,Genum.BonusLevel.ONE)
				Genum.BonusLevel.ONE:
					bonus_tracking[Genum.BonusType.ODD] = Genum.BonusLevel.TWO
					GameGlobalEvents.level_up.emit(Genum.BonusType.ODD,Genum.BonusLevel.TWO)
				Genum.BonusLevel.TWO:
					bonus_tracking[Genum.BonusType.ODD] = Genum.BonusLevel.MAX
					GameGlobalEvents.level_up.emit(Genum.BonusType.ODD,Genum.BonusLevel.MAX)
				Genum.BonusLevel.MAX:
					print("Max level, no upgrade possible")
		
	## ALPHA ETO SEVENS
	if !bonus_tracking.is_empty() :
		## ALPHABET
		if bonus_tracking.has(Genum.BonusType.ABC) and bonus_tracking.has(Genum.BonusType.XYZ) :
			bonus_tracking[Genum.BonusType.ALPHABET] = Genum.BonusLevel.MAXSECRET
			added_bonus.emit(Genum.BonusType.ALPHABET,Genum.BonusLevel.MAXSECRET)
		## ETO - DONE
		if bonus_tracking.has(Genum.BonusType.ODD) and bonus_tracking.has(Genum.BonusType.EVN) :
			if bonus_tracking[Genum.BonusType.ODD] == Genum.BonusLevel.MAX and bonus_tracking[Genum.BonusType.EVN] == Genum.BonusLevel.MAX:
				bonus_tracking[Genum.BonusType.ETO] = Genum.BonusLevel.MAXSECRET
				added_bonus.emit(Genum.BonusType.ETO,Genum.BonusLevel.MAXSECRET)
		## BONUS
		if bonus_tracking.has(Genum.BonusType.SEVENS) and bonus_tracking[Genum.BonusType.SEVENS] == Genum.BonusLevel.MAX :
			bonus_tracking[Genum.BonusType.BONUS] = Genum.BonusLevel.MAX
			added_bonus.emit(Genum.BonusType.BONUS,Genum.BonusLevel.MAX)
#	LCK-A - Lvl1 - TBaT 
	if card_chain[0] == DeckManager.card_resources[9].card_id and card_chain[1] == DeckManager.card_resources[12].card_id and card_chain[2] == DeckManager.card_resources[9].card_id :
		bonus_tracking[Genum.BonusType.LCKA] = Genum.BonusLevel.MAX
		added_bonus.emit(Genum.BonusType.LCKA,Genum.BonusLevel.MAX)
#	LCK-B - Lvl1 - TNUMT
	if card_chain[0] == DeckManager.card_resources[9].card_id and card_chain[1] <= DeckManager.card_resources[8].card_id and card_chain[2] == DeckManager.card_resources[9].card_id :
		bonus_tracking[Genum.BonusType.LCKB] = Genum.BonusLevel.MAX
		added_bonus.emit(Genum.BonusType.LCKB,Genum.BonusLevel.MAX)
#	LCK - LvlMAX - TTT
	if bonus_tracking.has(Genum.BonusType.LCKA) and bonus_tracking.has(Genum.BonusType.LCKB):
		bonus_tracking[Genum.BonusType.LCK] = Genum.BonusLevel.MAXSECRET
		added_bonus.emit(Genum.BonusType.LCK,Genum.BonusLevel.MAXSECRET)
#	BARTENDER - LvlMAX - BaBaBa
	if card_chain[0] == DeckManager.card_resources[12].card_id and card_chain[1] == DeckManager.card_resources[12].card_id and card_chain[2] == DeckManager.card_resources[12].card_id :
		bonus_tracking[Genum.BonusType.BARTENDER] = Genum.BonusLevel.MAX
		added_bonus.emit(Genum.BonusType.BARTENDER,Genum.BonusLevel.MAX)
#	OOF - LvlMAX - BoBoBo
	if card_chain[0] == DeckManager.card_resources[11].card_id and card_chain[1] == DeckManager.card_resources[11].card_id and card_chain[2] == DeckManager.card_resources[11].card_id :
		bonus_tracking[Genum.BonusType.OOF] = Genum.BonusLevel.MAX
		added_bonus.emit(Genum.BonusType.OOF,Genum.BonusLevel.MAX)
#	777 - Lvl1, Lvl2, LvlMAX
	if seven_counter % 3 == 0 and sevens:
		if !bonus_tracking.has(Genum.BonusType.SEVENS) :
			bonus_tracking[Genum.BonusType.SEVENS] = Genum.BonusLevel.ONE
			added_bonus.emit(Genum.BonusType.SEVENS,Genum.BonusLevel.ONE)
		elif bonus_tracking[Genum.BonusType.SEVENS] == 1:
			bonus_tracking[Genum.BonusType.SEVENS] = Genum.BonusLevel.TWO
			GameGlobalEvents.level_up.emit(Genum.BonusType.SEVENS,Genum.BonusLevel.TWO)
		elif bonus_tracking[Genum.BonusType.SEVENS] == 2:
			bonus_tracking[Genum.BonusType.SEVENS] = Genum.BonusLevel.MAX
			GameGlobalEvents.level_up.emit(Genum.BonusType.SEVENS,Genum.BonusLevel.MAX)
