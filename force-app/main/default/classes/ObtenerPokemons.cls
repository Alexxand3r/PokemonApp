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
        //Slots de movimientos
        Movimiento__c slot1, slot2, slot3, slot4;
        //List<Movimiento__c> moves = ObtenerMovientos();
        //Habilidad
        Habilidad__c Ability;
        
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
                    
                    pokelst.add(pokemon);
            }
        }
        insert pokelst;
    }
    global void finish(Database.BatchableContext BC) {
        system.debug('Batch finalizado');
    }
}