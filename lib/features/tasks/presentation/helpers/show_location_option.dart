import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/core/core_features.dart';

Future<dynamic> showLocationOptionsSheet({
  required BuildContext context,
  required LocationService locationService,
}) async {
  final TextEditingController searchController = TextEditingController();
  bool isSearchingManual = false;
  bool isSearchingGps = false;

  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: .vertical(top: .circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Como deseja indicar o local?",
                  style: TextStyle(fontSize: 18, fontWeight: .bold),
                  textAlign: .center,
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: "Pesquisar endereço",
                    hintText: "Ex: Av. Paulista, 1000 ou São Paulo - SP",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.map),
                    suffixIcon: isSearchingManual
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : IconButton(
                            onPressed: () async {
                              final text = searchController.text;
                              if (text.trim().isEmpty) return;

                              setModalState(() => isSearchingManual = true);

                              final result = await locationService
                                  .getFromAddressString(text);

                              setModalState(() => isSearchingManual = false);

                              if (context.mounted && result != null) {
                                Navigator.pop(context, result);
                              } else if (context.mounted) {
                                context.safeSnackBar(
                                  "Endereço não encontrado. Tente ser mais específico",
                                );
                              }
                            },
                            icon: const Icon(Icons.search, color: Colors.blue),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: isSearchingGps
                      ? null
                      : () async {
                          setModalState(() => isSearchingGps = true);

                          final result = await locationService
                              .getFullLocation();

                          setModalState(() => isSearchingGps = false);

                          if (context.mounted) {
                            Navigator.pop(context, result);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                  ),
                  icon: isSearchingGps
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.gps_fixed),
                  label: const Text(
                    "Usar minha localização atual (GPS)",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context, "MANUAL_MODE"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                  ),
                  icon: Icon(Icons.edit_location_alt, color: Colors.blue),
                  label: const Text(
                    "Digitar o endereço manualmente",
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      );
    },
  );
}
