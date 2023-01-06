global class ObtenerHabilidades implements Database.Batchable<Integer>, Database.AllowsCallouts, Database.Stateful {
    global Iterable<Integer> start(Database.BatchableContext bc){
        List<Integer> Scope = new List<Integer>();
        for (Integer s = 1; s <= 267; s++) {
            Scope.add(s);
        }
        return Scope;
    }
    
    global void execute(Database.BatchableContext bc, List<Integer> scope) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setMethod('GET');
        Map<String, Object> resultBodyA = new Map <String,Object>();
        List<Habilidad__c> hablst = new List<Habilidad__c>();
        String name = '';
        Habilidad__c ability = new Habilidad__c();
        for(Integer s : scope){
            request.setEndpoint('https://pokeapi.co/api/v2/ability/' + s);
            response = http.send(request);
            if(response.getStatusCode() == 200 ){
                resultBodyA = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                name = (String)resultBodyA.get('name');
                
                ability.Name = name.capitalize();
                ability.ExtId__c = (Integer)resultBodyA.get('id');
                
                // Campo Efecto__c
                List<Object> effectentries =(List<Object>) resultBodyA.get('effect_entries');
                for(Object efecto : effectentries){
                   
                    Map<String,Object> searchEng = (Map<String,Object>) efecto;
                    Map<String,Object> language = (Map<String,Object>) searchEng.get('language');
                    
                    if((String) language.get('name') == 'en'){
                        ability.Efecto__c = (String)searchEng.get('short_effect');
                    } else {
                        ability.Efecto__c = null;
                    }
                }
                //insert ability;
            hablst.add(ability);   
            }            
        }
         //insert ability;
        insert hablst;
    }
      
    global void finish(Database.BatchableContext BC) {
        system.debug('Batch habilidad finalizado');
    }
}