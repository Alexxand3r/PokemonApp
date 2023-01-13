@isTest
public class ObtenerPokemonsTest {
    @testSetup
    static void setup() {
              
        Habilidad__c habil1 = new Habilidad__c(Name = 'Overgrow');
        insert habil1;
       	Habilidad__c habil2 = new Habilidad__c(Name = 'Chlorophyll');
        insert habil2;
        Movimiento__c move1 = new Movimiento__c(Name = 'Bind');
        insert move1;
        Movimiento__c move2 = new Movimiento__c(Name = 'Cut');
        insert move2;
        Movimiento__c move3 = new Movimiento__c(Name = 'Swords-dance');
        insert move3;
        Movimiento__c move4 = new Movimiento__c(Name = 'Razor-wind');
        insert move4;
        Movimiento__c move5 = new Movimiento__c(Name = 'Vine-whip');
        insert move5;
        
        
    }
    @isTest 
    static void testInsertCompletePokemon() {
        
        SingleRequestMock fakeResponse = new SingleRequestMock(200,
                                                               'OK',
                                                               '{"id":1,'+
                                                               '"name":"bulbasaur",'+
                                                               '"height":7,'+
                                                               ',"weight":69,'+
                                                               '"abilities":[{"ability":{"name":"overgrow","url":"https://pokeapi.co/api/v2/ability/65/"},"is_hidden":false,"slot":1},{"ability":{"name":"chlorophyll","url":"https://pokeapi.co/api/v2/ability/34/"},"is_hidden":true,"slot":3}],'+
                                                               '"moves":[{"move":{"name":"razor-wind","url":"https://pokeapi.co/api/v2/move/13/"}},{"move":{"name":"swords-dance","url":"https://pokeapi.co/api/v2/move/14/"}},{"move":{"name":"cut","url":"https://pokeapi.co/api/v2/move/15/"}},{"move":{"name":"bind","url":"https://pokeapi.co/api/v2/move/20/"}},{"move":{"name":"vine-whip","url":"https://pokeapi.co/api/v2/move/22/"}}],'+
                                                               '"sprites":{"back_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png","back_female":null,"back_shiny":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/1.png","back_shiny_female":null,"front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png","front_female":null,"front_shiny":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png","front_shiny_female":null,"other":{"dream_world":{"front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg","front_female":null},"home":{"front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/1.png","front_female":null,"front_shiny":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/shiny/1.png","front_shiny_female":null},"official-artwork":{"front_default":"https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"}}},'+
                                                               '"stats":[{"base_stat":45,"effort":0,"stat":{"name":"hp","url":"https://pokeapi.co/api/v2/stat/1/"}},{"base_stat":49,"effort":0,"stat":{"name":"attack","url":"https://pokeapi.co/api/v2/stat/2/"}},{"base_stat":49,"effort":0,"stat":{"name":"defense","url":"https://pokeapi.co/api/v2/stat/3/"}},{"base_stat":65,"effort":1,"stat":{"name":"special-attack","url":"https://pokeapi.co/api/v2/stat/4/"}},{"base_stat":65,"effort":0,"stat":{"name":"special-defense","url":"https://pokeapi.co/api/v2/stat/5/"}},{"base_stat":45,"effort":0,"stat":{"name":"speed","url":"https://pokeapi.co/api/v2/stat/6/"}}],'+
                                                               '"types":[{"slot":1,"type":{"name":"grass","url":"https://pokeapi.co/api/v2/type/12/"}},{"slot":2,"type":{"name":"poison","url":"https://pokeapi.co/api/v2/type/4/"}}]}',
                                                                null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
  
        
        Test.startTest();
                       
        Id batchId = Database.executeBatch(new ObtenerPokemons(),1);
        Test.stopTest();
        
        Pokemon__c pokeLst = [SELECT Id, Name, ExtId__c, Altura__C,Peso__c, Tipos__c, Generacion__c, Vida__c, Defensa__c, Ataque__c,
                           Velocidad__c, Imagen__c, Habilidad__c, Slot1__c, Slot2__c, Slot3__c, Slot4__c
                           FROM Pokemon__c
                           LIMIT 1];
        
        System.assertEquals('Bulbasaur', pokeLst.Name );
        System.assertEquals('Poison;Grass', pokeLst.Tipos__c);
        System.assertEquals('https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/' + pokeLst.ExtId__c + '.gif',
                            pokeLst.Imagen__c);
        System.assertEquals(1, pokeLst.ExtId__c);
        System.assertEquals(1, pokeLst.Generacion__c);
        System.assertEquals(6.9, pokeLst.Peso__c);
        System.assertEquals(0.7, pokeLst.Altura__c);
        System.assertEquals(45, pokeLst.Vida__c);
        System.assertEquals(45, pokeLst.Velocidad__c);
        System.assertEquals(49, pokeLst.Defensa__c);
        System.assertEquals(49, pokeLst.Ataque__c);
        System.assertNotEquals(null, pokeLst.Habilidad__c);
        System.assertNotEquals(null, pokeLst.Slot1__c);
        System.assertNotEquals(null, pokeLst.Slot2__c);
        System.assertNotEquals(null, pokeLst.Slot3__c);
        System.assertNotEquals(null, pokeLst.Slot4__c);
    }
    @isTest 
    static void testNoResponse() {
         
        SingleRequestMock fakeResponse = new SingleRequestMock(404,
                                                               'Not Found',
                                                               '',
                                                                null);
        Test.setMock(HttpCalloutMock.class, fakeResponse); 
                
             Test.startTest();
       
       
        Id batchId = Database.executeBatch(new ObtenerPokemons(),1);
        Test.stopTest();
        
       System.assertEquals(0, [SELECT count() FROM Pokemon__c] );
    }
}