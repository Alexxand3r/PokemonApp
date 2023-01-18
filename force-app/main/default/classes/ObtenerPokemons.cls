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
                pokemon.Imagen__c = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/' + pokemon.ExtId__c + '.png';
                
                pokemon.Vida__c = (Integer) ((Map<String, Object>)properties[0]).get('base_stat');
                pokemon.Ataque__c = (Integer) ((Map<String, Object>)properties[1]).get('base_stat');
                pokemon.Defensa__c = (Integer) ((Map<String, Object>)properties[2]).get('base_stat');
                pokemon.Velocidad__c = (Integer) ((Map<String, Object>)properties[5]).get('base_stat');
                
                // Campo Tipos__c
                List<Object> types =(List<Object>) resultBody.get('types');
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
                List<Object> abilities = (List<Object>) resultBody.get('abilities');
                Map<String,Object> abilitiesn = (Map<String,Object>) abilities.get(Integer.valueOf(Math.random()*abilities.size()));
                Map<String,Object> ability = (Map<String,Object>) abilitiesn.get('ability');
                String abilityname = (String) ability.get('name');
                Habilidad__c habid = [SELECT Id 
                                      FROM Habilidad__c 
                                      WHERE Name = :abilityname.capitalize()
                                      LIMIT 1];
                
                pokemon.Habilidad__c = habid.id;
                
                // Campo Slot relacionado al objeto Movimiento__c
                List<Object> movi = (List<Object>) resultBody.get('moves');
                if (movi.size() >= 4) {
                    Map<String,Object> movi0 =(Map<String,Object>) movi.get(0);
                    Map<String,Object> movi00 =(Map<String,Object>) movi0.get('move');
                    String moviName = (String) movi00.get('name'); 
                    Map<String,Object> movi1 =(Map<String,Object>) movi.get(1);
                    Map<String,Object> movi01 =(Map<String,Object>) movi1.get('move');
                    String moviName1 = (String) movi01.get('name'); 
                    Map<String,Object> movi2 =(Map<String,Object>) movi.get(2);
                    Map<String,Object> movi02 =(Map<String,Object>) movi2.get('move');
                    String moviName2 = (String) movi02.get('name');
                    Map<String,Object> movi3 =(Map<String,Object>) movi.get(3);
                    Map<String,Object> movi03 =(Map<String,Object>) movi3.get('move');
                    String moviName3 = (String) movi03.get('name');
                    Movimiento__c slot1= [SELECT Id FROM Movimiento__c WHERE Name = :moviName LIMIT 1];
                    pokemon.Slot1__c = slot1.Id;
                    Movimiento__c slot2 = [SELECT Id FROM Movimiento__c WHERE Name = :moviName1 LIMIT 1];
                    pokemon.Slot2__c = slot2.Id;
                    Movimiento__c slot3 = [SELECT Id FROM Movimiento__c WHERE Name = :moviName2 LIMIT 1];
                    pokemon.Slot3__c = slot3.Id;
                    Movimiento__c slot4 = [SELECT Id FROM Movimiento__c WHERE Name = :moviName3 LIMIT 1];
                    pokemon.Slot4__c = slot4.Id;
                }else {
                    if (movi.size() == 3) {
                        Map<String,Object> movi0 =(Map<String,Object>) movi.get(0);
                        Map<String,Object> movi00 =(Map<String,Object>) movi0.get('move');
                        String moviName = (String) movi00.get('name'); 
                        Map<String,Object> movi1 =(Map<String,Object>) movi.get(1);
                        Map<String,Object> movi01 =(Map<String,Object>) movi1.get('move');
                        String moviName1 = (String) movi01.get('name'); 
                        Map<String,Object> movi2 =(Map<String,Object>) movi.get(2);
                        Map<String,Object> movi02 =(Map<String,Object>) movi2.get('move');
                        String moviName2 = (String) movi02.get('name');
                        Movimiento__c slot1= [SELECT Id FROM Movimiento__c WHERE Name = :moviName LIMIT 1];
                        pokemon.Slot1__c = slot1.Id;
                        Movimiento__c slot2 = [SELECT Id FROM Movimiento__c WHERE Name = :moviName1 LIMIT 1];
                        pokemon.Slot2__c = slot2.Id;
                        Movimiento__c slot3 = [SELECT Id FROM Movimiento__c WHERE Name = :moviName2 LIMIT 1];
                        pokemon.Slot3__c = slot3.Id;
                    }else {
                        if (movi.size() == 2) {
                            Map<String,Object> movi0 =(Map<String,Object>) movi.get(0);
                            Map<String,Object> movi00 =(Map<String,Object>) movi0.get('move');
                            String moviName = (String) movi00.get('name'); 
                            Map<String,Object> movi1 =(Map<String,Object>) movi.get(1);
                            Map<String,Object> movi01 =(Map<String,Object>) movi1.get('move');
                            String moviName1 = (String) movi01.get('name'); 
                            Movimiento__c slot1 = [SELECT Id FROM Movimiento__c WHERE Name = :moviName LIMIT 1];
                            pokemon.Slot1__c = slot1.Id;
                            Movimiento__c slot2 = [SELECT Id FROM Movimiento__c WHERE Name = :moviName1 LIMIT 1];
                            pokemon.Slot2__c = slot2.Id;
                        } else {
                            if (movi.size() == 1) {
                                Map<String,Object> movi0 =(Map<String,Object>) movi.get(0);
                                Map<String,Object> movi00 =(Map<String,Object>) movi0.get('move');
                                String moviName = (String) movi00.get('name'); 
                                Movimiento__c slot1  = [SELECT Id FROM Movimiento__c WHERE Name = :moviName LIMIT 1];
                                pokemon.Slot1__c = slot1.Id;
                            }
                            
                        }
                        
                    }
                    
                }
                
                insert pokemon;
            }
        }
    }
    
    
    global void finish(Database.BatchableContext BC) {
        system.debug('Batch Pokemon finalizado');
    }
}