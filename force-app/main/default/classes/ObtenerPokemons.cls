global class ObtenerPokemons implements Database.Batchable<Integer>, Database.AllowsCallouts, Database.Stateful {
    global Iterable<Integer> start(Database.BatchableContext bc){
        List<Integer> Scope = new List<Integer>();
        for (Integer s = 1; s <= 898; s++) {
            Scope.add(s);
        }
        return Scope;
    }
    global void execute(Database.BatchableContext bc, List<Integer> scope) {
        
        List<Pokemon__c> pokelst = new List<Pokemon__c>();
        Map<String, Object> resultBody  = new Map <String,Object>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setMethod('GET');
        String name = '';              
        List<Object> properties = new List<Object>();
        
        for(Integer s : scope){
            request.setEndpoint('https://pokeapi.co/api/v2/pokemon/' + s);
            response = http.send(request);
            if(response.getStatusCode() == 200 ){
                resultBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                name = (String)resultBody.get('name');
                properties = (List<Object>) resultBody.get('stats');
                Pokemon__c pokemon = new Pokemon__c();
                pokemon.Name = name.capitalize();
                pokemon.Peso__c = (Double)resultBody.get('weight')/10;
                pokemon.Altura__c = (Double)resultBody.get('height')/10;
                pokemon.ExtId__c = (Integer)resultBody.get('id');
                if ((integer)pokemon.ExtId__c < 650) {
                    pokemon.Imagen__c = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/' +pokemon.ExtId__c + '.gif';
                } else {
                    pokemon.Imagen__c = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/'+ pokemon.ExtId__c + '.png';
                }
                pokemon.Vida__c = (Integer) ((Map<String, Object>)properties[0]).get('base_stat');
                pokemon.Ataque__c = (Integer) ((Map<String, Object>)properties[1]).get('base_stat');
                pokemon.Defensa__c = (Integer) ((Map<String, Object>)properties[2]).get('base_stat');
                pokemon.Velocidad__c = (Integer) ((Map<String, Object>)properties[5]).get('base_stat');
                
                //Mapa JSON completo que devuelve el response, deserializado
                Map<String,Object> pokeMap =(Map<String,Object>) JSON.deserializeUntyped(response.getBody());
                
                // Campo Tipos__c
                List<Object> types =(List<Object>) pokeMap.get('types');
                Map<String,Object> type0 =(Map<String,Object>) types.get(0);
                Map<String,Object> type00 = (Map<String,Object>) type0.get('type');
                String typename0 = (String) type00.get('name');
                pokemon.Tipos__c = typename0.capitalize();
                if (types.size() > 1){
                    Map<String,Object> type1 =(Map<String,Object>) types.get(1);
                    Map<String,Object> type01 = (Map<String,Object>) type1.get('type');
                    String typename1 = (String) type01.get('name');
                    pokemon.Tipos__c = typename0.capitalize()+';'+typename1.capitalize();
                }                               
                
                // Campo Habilidad__c relacionado objeto Habilidad__c
                List<Object> abilities = (List<Object>) pokeMap.get('abilities');
                Map<String,Object> abilitiesn = (Map<String,Object>) abilities.get(Integer.valueOf(Math.random()*abilities.size()));
                Map<String,Object> ability = (Map<String,Object>) abilitiesn.get('ability');
                String abilityname = (String) ability.get('name');
                Habilidad__c habid = [SELECT Id 
                                      FROM Habilidad__c 
                                      WHERE Name = :abilityname.capitalize()
                                      LIMIT 1];
                
                pokemon.Habilidad__c = habid.id;
                
                // Campo Slot__c al relacionado objeto Movimiento__c
                List<Object> moves = (List<Object>) pokeMap.get('moves');
                Integer count = 0;
                List<Integer> nMov = new List<Integer>();
                while ( count < moves.size() && count < 4 ){
                    Integer numero = Integer.valueOf(Math.random()*moves.size());
                    if (count == 0){
                        nMov.add(numero);
                        count++;
                    }
                    if (count == 1 && nMov.get(0) != numero){
                        nMov.add(numero);
                        count++;
                    }
                    if (count == 2 && nMov.get(0) != numero && nMov.get(1) != numero){
                        nMov.add(numero);
                        count++;
                    }
                    if (count == 3 && nMov.get(0) != numero && nMov.get(1) != numero && nMov.get(2) != numero){
                        nMov.add(numero);
                        count++;
                    }
                }
                if (moves.size() > 0){
                    Map<String,Object> moves0 = (Map<String,Object>) moves.get(nMov.get(0));
                    Map<String,Object> move0 = (Map<String, Object>) moves0.get('move');
                    String movename0 = (String) move0.get('name');
                    Movimiento__c movi0 = [SELECT Id 
                                           FROM Movimiento__c 
                                           WHERE Name = :movename0.capitalize()
                                           LIMIT 1];
                    pokemon.Slot1__c = movi0.id;
                }
                if (moves.size() > 1){
                    Map<String,Object> moves1 = (Map<String,Object>) moves.get(nMov.get(1));
                    Map<String,Object> move1 = (Map<String, Object>) moves1.get('move');
                    String movename1 = (String) move1.get('name');
                    Movimiento__c movi1 = [SELECT Id 
                                           FROM Movimiento__c 
                                           WHERE Name = :movename1.capitalize()
                                           LIMIT 1];
                    pokemon.Slot2__c = movi1.id;
                }
                if (moves.size() > 2){
                    Map<String,Object> moves2 = (Map<String,Object>) moves.get(nMov.get(2));
                    Map<String,Object> move2 = (Map<String, Object>) moves2.get('move');
                    String movename2 = (String) move2.get('name');
                    Movimiento__c movi2 = [SELECT Id 
                                           FROM Movimiento__c 
                                           WHERE Name = :movename2.capitalize()
                                           LIMIT 1];
                    pokemon.Slot3__c = movi2.id;
                }
                if (moves.size() > 3){
                    Map<String,Object> moves3 = (Map<String,Object>) moves.get(nMov.get(3));
                    Map<String,Object> move3 = (Map<String, Object>) moves3.get('move');
                    String movename3 = (String) move3.get('name');
                    
                    Movimiento__c movi3 = [SELECT Id 
                                           FROM Movimiento__c 
                                           WHERE Name = :movename3.capitalize()
                                           LIMIT 1];
                    pokemon.Slot4__c = movi3.id;
                }               
                pokelst.add(pokemon);
            }
        }
        insert pokelst;
    }
    global void finish(Database.BatchableContext BC) {
        system.debug('Batch Pokemon finalizado');
    }
}