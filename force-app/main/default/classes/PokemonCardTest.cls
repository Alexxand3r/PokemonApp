@isTest
public class PokemonCardTest {
    @isTest static void buscarPokemons(){
        Pokemon__c poke = new Pokemon__c( Name= 'Bulbasaur',
                                         Tipos__c= 'Poison;Grass',
                                         Imagen__c= 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
                                         ExtId__c=1);
       insert poke;
       Test.startTest();
        PokemonCard.buscarPokemons();
       Test.stopTest();
      List<Pokemon__c> pokeLst = [
            SELECT Id, Name, Tipos__c,Generacion__c, Imagen__c, ExtId__c FROM Pokemon__c
        ];
        System.assertEquals(1,pokeLst.size(),'error');
        System.assertEquals('Bulbasaur',pokeLst[0].Name);
        System.assertEquals('Poison;Grass',pokeLst[0].Tipos__c);
        System.assertEquals('https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/' + poke.ExtId__c + '.png',pokeLst[0].Imagen__c );
        System.assertEquals(1,pokeLst[0].ExtId__c );
        System.assertEquals(1,pokeLst[0].Generacion__c );
    }
}