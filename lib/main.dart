
import 'package:flutter/material.dart';
import 'poke.dart';

void main() {
  const Map<String, dynamic> rawJson = {
    "id": 616,
    "name": "shelmet",
    "type": "bug",
    "base_experience": 61,
    "height": 4,
    "weight": 77,
    "abilities": [
      {
        "is_hidden": false,
        "slot": 1,
        "ability": {"name": "hydration", "url": ""}
      },
      {
        "is_hidden": false,
        "slot": 2,
        "ability": {"name": "shell-armor", "url": ""}
      },
      {
        "is_hidden": true,
        "slot": 3,
        "ability": {"name": "overcoat", "url": ""}
      }
    ],
    "held_items": [],
    "moves": [
      {"move": {"name": "body-slam", "url": ""}},
      {"move": {"name": "acid", "url": ""}},
      {"move": {"name": "recover", "url": ""}},
      {"move": {"name": "bug-buzz", "url": ""}}
    ],
    "sprites": {
      "other": {
        "official-artwork": {
          "front_default":
              "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/616.png"
        }
      }
    }
  };

  final Pokemon pokemon = Pokemon.fromJson(rawJson);

  runApp(PokemonApp(pokemon: pokemon));
}

class PokemonApp extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonApp({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokemon Data Model',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Pokémon Profile: ${pokemon.name.toUpperCase()}',
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Image.network(
                pokemon.spriteUrl,
                height: 180,
                width: 180,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 100);
                },
              ),
            ),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow('ID', pokemon.id.toString()),
                    _infoRow('Name', pokemon.name),
                    _infoRow('Type', pokemon.type),
                    _infoRow(
                      'Base Experience',
                      pokemon.baseExperience.toString(),
                    ),
                    _infoRow('Height', pokemon.height.toString()),
                    _infoRow('Weight', pokemon.weight.toString()),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            _sectionTitle('Abilities'),

            ...pokemon.abilities.map(
              (ability) => Card(
                color: Colors.green.shade50,
                child: ListTile(
                  leading: const Icon(
                    Icons.star,
                    color: Colors.green,
                  ),
                  title: Text(
                    ability.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Slot: ${ability.slot} | Hidden: ${ability.isHidden}',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            _sectionTitle('Held Items'),

            if (pokemon.heldItems.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('No held items'),
              )
            else
              ...pokemon.heldItems.map(
                (item) => ListTile(
                  leading: const Icon(Icons.inventory_2),
                  title: Text(item),
                ),
              ),

            const SizedBox(height: 20),
            _sectionTitle('Moves'),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pokemon.moves
                  .map(
                    (move) => Chip(
                      label: Text(move.name),
                      backgroundColor: Colors.green.shade100,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 145,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
