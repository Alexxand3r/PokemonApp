@isTest
public class ObtenerHabilidadesTest {
      @isTest 
    static void testLangnameEnSecondPlace() {
        
        SingleRequestMock fakeResponse = new SingleRequestMock(200,
                                                               'OK',
                                                               '{"id":1,'+
                                                               '"name":"stench",'+
                                                               '"effect_entries":[{"effect":"Attacken die Schaden","language":{"name":"de","url":"https://pokeapi.co/api/v2/language/6/"},"short_effect":"Mit jedem Treffer"},'+
                                                               '{"effect":"This Pokemons damaging move.","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Has a 10% chance of making target Pokémon flinch with each hit."}]}',
                                                                null);
        Test.setMock(HttpCalloutMock.class, fakeResponse); 
        Test.startTest();              
        Id batchId = Database.executeBatch(new ObtenerHabilidades(),1);
        Test.stopTest();
        
        Habilidad__c habLst = [SELECT Id, Name, ExtId__c, Efecto__c 
                              FROM Habilidad__c 
                              LIMIT 1];
        
        System.assertEquals('Stench', habLst.Name );
        System.assertEquals(1, habLst.ExtId__c);
        System.assertEquals('Has a 10% chance of making target Pokémon flinch with each hit.', habLst.Efecto__c);
    }
   
    @isTest 
    static void testNoResponse() {
         
        SingleRequestMock fakeResponse = new SingleRequestMock(404,
                                                               'Not Found',
                                                               '',
                                                                null);
        Test.setMock(HttpCalloutMock.class, fakeResponse); 
        
        Test.startTest();
               Id batchId = Database.executeBatch(new ObtenerHabilidades(),1);
        Test.stopTest();
        
        System.assertEquals(0, [SELECT count() FROM Habilidad__c] );
    }
}