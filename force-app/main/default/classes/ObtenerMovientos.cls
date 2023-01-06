global class ObtenerMovientos implements Database.Batchable<Integer>, Database.AllowsCallouts, Database.Stateful {
    global Iterable<Integer> start(Database.BatchableContext bc){
        List<Integer> Scope = new List<Integer>();
        for (Integer s = 1; s <= 826; s++) {
            Scope.add(s);
        }
        return Scope;
    }
    global void execute(Database.BatchableContext bc, List<Integer> scope) {
        List<Movimiento__c> movelst = new List<Movimiento__c>();
        Map<String, Object> resultBodyM  = new Map <String,Object>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        request.setMethod('GET');
        String name = '';
        List<Object> properties = new List<Object>();
        for(Integer s : scope){
            request.setEndpoint('https://pokeapi.co/api/v2/move/' + s);
            response = http.send(request);
            if(response.getStatusCode() == 200 ){
                resultBodyM = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                name = (String)resultBodyM.get('name');
                properties = (List<Object>) resultBodyM.get('stats');
                Movimiento__c move = new Movimiento__c();
                move.Name = name.capitalize();
                move.Punteria__c = (Integer)resultBodyM.get('accuracy');
                move.Pp__c = (Integer)resultBodyM.get('pp');
                move.Poder__c = (Double)resultBodyM.get('power');
                move.Prioridad__c = (Integer)resultBodyM.get('priority');
                move.ExtId__c = (Integer)resultBodyM.get('id');
                
                // Mapa que contiene el JSON completo que devuelve como respuesta la API, deserializado
                Map<String,Object> mov =(Map<String,Object>) JSON.deserializeUntyped(response.getBody());
                
                // Campos Chance_de_Efecto__c y Efecto__c
                // 
                // 
                // Campo Objetivo__c 
                Map<String,Object> target = (Map<String,Object>) mov.get('target');
                String targetname = (String) target.get('name');
                move.Objetivo__c = targetname;

                // Campo Tipo__c 
                 Map<String,Object> type = (Map<String,Object>) mov.get('type');
                 String typename = (String) type.get('name');
                 move.Tipo__c = typename.capitalize();
                
              
                movelst.add(move);
            }
        }
        insert movelst;
    }
    global void finish(Database.BatchableContext bc) {
        system.debug('Batch finalizado');
    }
}