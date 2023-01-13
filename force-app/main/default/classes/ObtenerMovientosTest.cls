@isTest
public class ObtenerMovientosTest {
    @isTest 
    static void testEffectChanceNull() {
          
        SingleRequestMock fakeResponse = new SingleRequestMock(200,
                                                               'OK',
                                                               '{"id":1,'+
                                                               '"name":"pound",'+
                                                               '"power":40,'+
                                                               '"pp":35,'+
                                                               '"accuracy":100,'+
                                                               '"effect_chance":null,'+
                                                               '"effect_entries":[{"effect":"Inflicts regular damage.","language":{"name":"en","url":"https://pokeapi.co/api/v2/language/9/"},"short_effect":"Inflicts regular damage with no additional effect."}],'+
                                                               '"priority":0,'+
                                                               '"target":{"name":"selected-pokemon","url":"https://pokeapi.co/api/v2/move-target/10/"},'+
                                                               '"type":{"name":"normal","url":"https://pokeapi.co/api/v2/type/1/"}}',
                                                                null);
        Test.setMock(HttpCalloutMock.class, fakeResponse); 
        Test.startTest();               
        Id batchId = Database.executeBatch(new ObtenerMovientos(),1);
        Test.stopTest();
        
        Movimiento__c moveLst = [SELECT Id, Name, ExtId__c, pp__C, Punteria__c, Prioridad__c, Poder__c, Chance_de_Efecto__c, Efecto__c
                             FROM Movimiento__c
                             LIMIT 1];
        
        System.assertEquals('Pound', moveLst.Name );
        System.assertEquals(1, moveLst.ExtId__c);
        System.assertEquals(35, moveLst.pp__c);
        System.assertEquals(100, moveLst.Punteria__c);
        System.assertEquals(0, moveLst.Prioridad__c);
        System.assertEquals(40, moveLst.Poder__c);
        System.assertEquals(0, moveLst.Chance_de_Efecto__c);
        System.assertEquals('Inflicts regular damage with no additional effect.', moveLst.Efecto__c);
    }
  

    @isTest 
    static void testSinResponse() {
        
        SingleRequestMock fakeResponse = new SingleRequestMock(404,
                                                               'Not Found',
                                                               '',
                                                                null);
        Test.setMock(HttpCalloutMock.class, fakeResponse); 
        
             Test.startTest();
       
       
        Id batchId = Database.executeBatch(new ObtenerMovientos(),1);
        Test.stopTest();
        
        System.assertEquals(0, [SELECT count() FROM Movimiento__c] );
    }
}