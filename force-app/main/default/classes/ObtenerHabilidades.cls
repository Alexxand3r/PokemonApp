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
      
        for(Integer s : scope){
            request.setEndpoint('https://pokeapi.co/api/v2/ability/' + s);
            response = http.send(request);
            Habilidad__c ability = new Habilidad__c();
            if(response.getStatusCode() == 200 ){
                resultBodyA = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                name = (String)resultBodyA.get('name');
               
                ability.Name = name.capitalize();
                ability.ExtId__c = (Integer)resultBodyA.get('id');
                
             // Campo Efecto__c
             Map<String,Object> abil =(Map<String,Object>) JSON.deserializeUntyped(response.getBody());
             List<Object> effectentries =(List<Object>) abil.get('effect_entries');
               if (effectentries.size() > 0 ){
                  Map<String,Object> searchEng = (Map<String,Object>) effectentries.get(0);
                  Map<String,Object> language = (Map<String,Object>) searchEng.get('language');
                  String idioma = (String) language.get('name');
               if (idioma.equals('en')){
                    String shorteffect = (String) searchEng.get('short_effect');
                    ability.Efecto__c = shorteffect;
                } else {
                    Map<String,Object> english = (Map<String,Object>) effectentries.get(1);
                    String shorteffect = (String) english.get('short_effect');
                    ability.Efecto__c = shorteffect;
                }
            }
              
                hablst.add(ability);
            }
        }
        insert hablst;
    }
    global void finish(Database.BatchableContext BC) {
        system.debug('Batch habilidad finalizado');
    }
}