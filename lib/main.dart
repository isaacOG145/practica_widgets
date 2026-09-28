import 'package:flutter/material.dart';

void main(){
  runApp(
    const MyApp()
  );
}

class MyApp extends StatelessWidget{
  
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Lista viva DMI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const ListaVivaPage(
        title: 'Equipo 10B'
    )
    );
  }
}

class ListaVivaPage extends StatefulWidget{
   const ListaVivaPage({super.key, required this.title});

   final String title;

   @override
  State<ListaVivaPage> createState() => _ListaVivaPageState();
}

class _ListaVivaPageState extends State<ListaVivaPage>{

  List<String> _materiales = ['Cable USB','Protoboard','Resistencias', 'LED']; // nombres
  List<int> _cantidades = [5,2,10,1]; // stock de cada material (mismo índice)
  bool _soloStockBajo = false; //filtro

  /// Funciones
  void _restart(){
    setState(() {
      for(int i = 0; i < _cantidades.length; i++){
        _cantidades[i] = 0;
      }
    });
  }

  void _addItem(){
    setState(() {
      _materiales.add('Material ${_materiales.length + 1}');
      _cantidades.add(0);
    });
  }


  void _subtract(int index){
    setState(() {
      if(_cantidades[index] > 0 ){
        _cantidades[index]--;
      }
    });
  }

  void _add(int index){
    setState(() {
      _cantidades[index]++;
    });
  }

  void _delete(int index){
    setState(() {
      _materiales.removeAt(index);
      _cantidades.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context){

    int total = _cantidades.fold(0, (acumulado, elem) => acumulado + elem);

    List<int> indicesVisibles = [];
    for (int i = 0; i < _materiales.length; i++) {
      if (!_soloStockBajo || _cantidades[i] <= 2) {
        indicesVisibles.add(i);
      }
    }

    return Scaffold(
      //APP BAR - HEADER
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(widget.title),
        centerTitle: true,
        //Boton de reiniciar
        actions: [
          IconButton(
              tooltip: 'Reiniciar',
              onPressed: _restart,
              icon: const Icon(Icons.restart_alt)
          ),
        ],
      ),
      //BODY- BLOQUES EN COLUMNA
      body: Column(
        //Bloques principales
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //Mini elemento
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //Textos
              children: [
                Text(
                    'Materiales: ${_materiales.length}'
                ),
                Text(
                    'Total: $total'
                ),
              ],
            ),
          ),
          //Switch
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Solo stock bajo'),
                const SizedBox(width: 8),
                Switch(value: _soloStockBajo, onChanged: (value){
                  setState(() {
                    _soloStockBajo = value;
                  });
                })
              ],
            ),
          ),
          //Divisor
          const Divider(height: 1),

          Expanded(
            child: ListView.builder(
              itemCount: indicesVisibles.length,
              itemBuilder: (context, index) {

                int originalIndex = indicesVisibles[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${originalIndex + 1}'),
                    ),
                    title: Text(_materiales[originalIndex]),
                    subtitle: Text('Cantidad: ${_cantidades[originalIndex]}'), // Cerramos Text aquí
                    trailing: Row( // trailing va al mismo nivel que title y subtitle
                      mainAxisSize: MainAxisSize.min, // Evita errores de ancho/overflow
                      children: [
                        IconButton(
                          onPressed: () => _subtract(index), // O la función que uses
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        IconButton(
                          onPressed: () => _add(index),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                        IconButton(
                          onPressed: () => _delete(index),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

        ],
      ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _addItem,
          icon: const Icon(Icons.person_add),
          label: const Text('Agregar'),
        )
    );
  }
}