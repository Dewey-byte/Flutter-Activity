class Pokemon {
  final int id;
  final String name;
  final String type;
  final int baseExperience;
  final int height;
  final int weight;
  final List<AbilityEntry> abilities;
  final List<String> heldItems;
  final List<MoveEntry> moves;
  final String spriteUrl;

  Pokemon({
    required this.id,
    required this.name,
    required this.type,
    required this.baseExperience,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.heldItems,
    required this.moves,
    required this.spriteUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    var abilitiesList = json['abilities'] as List? ?? [];
    List<AbilityEntry> parsedAbilities = abilitiesList
        .map((abilityJson) => AbilityEntry.fromJson(abilityJson))
        .toList();

    var heldItemsList = json['held_items'] as List? ?? [];
    List<String> parsedHeldItems =
        heldItemsList.map((item) => item['item']['name'].toString()).toList();

    var movesList = json['moves'] as List? ?? [];
    List<MoveEntry> parsedMoves =
        movesList.map((moveJson) => MoveEntry.fromJson(moveJson)).toList();

    String extractedSprite = '';
    try {
      extractedSprite = json['sprites']['other']['official-artwork']
              ['front_default'] ??
          json['sprites']['front_default'] ??
          '';
    } catch (_) {
      extractedSprite = '';
    }

    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['name'] as String,
      baseExperience: json['base_experience'] as int,
      height: json['height'] as int,
      weight: json['weight'] as int,
      abilities: parsedAbilities,
      heldItems: parsedHeldItems,
      moves: parsedMoves,
      spriteUrl: extractedSprite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'base_experience': baseExperience,
      'height': height,
      'weight': weight,
      'abilities': abilities.map((a) => a.toJson()).toList(),
      'held_items': heldItems,
      'moves': moves.map((m) => m.toJson()).toList(),
      'sprite_url': spriteUrl,
    };
  }
}

class AbilityEntry {
  final String name;
  final int slot;
  final bool isHidden;

  AbilityEntry(
      {required this.name, required this.slot, required this.isHidden});

  factory AbilityEntry.fromJson(Map<String, dynamic> json) {
    return AbilityEntry(
      name: json['ability']['name']['type'] as String,
      slot: json['slot'] as int,
      isHidden: json['is_hidden'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slot': slot,
      'is_hidden': isHidden,
    };
  }
}

class MoveEntry {
  final String name;

  MoveEntry({required this.name});

  factory MoveEntry.fromJson(Map<String, dynamic> json) {
    return MoveEntry(
      name: json['move']['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
