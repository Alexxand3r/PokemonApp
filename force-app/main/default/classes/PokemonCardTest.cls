@isTest
public class PokemonCardTest {
    @isTest static void buscarPokemons(){
        Pokemon__c poke = new Pokemon__c( Name= 'bulbasaur',
                                         Tipos__c= 'Poison;Grass',
                                         Altura__c= 0.70,
                                         Peso__c= 6.90,
                                         Imagen__c= 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/1.gif',
                                         ExtId__c=1);  
       Test.startTest();              
        PokemonCard.buscarPokemons();
       Test.stopTest();
        
       List<Pokemon__c> pokeLst = [
            SELECT Id, Name, Tipos__c, Altura__c, Peso__c, Generacion__c, Imagen__c, ExtId__c FROM Pokemon__c 
        ];
        
        System.assertEquals(poke.Name,'Bulbasaur');
        System.assertEquals(poke.Tipos__c,'Poison;Grass');
        System.assertEquals(poke.Imagen__c,'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-v/black-white/animated/' + poke.ExtId__c + '.gif' );
        System.assertEquals(poke.ExtId__c,1 );
        System.assertEquals(poke.Generacion__c,1 );
        System.assertEquals(poke.Peso__c,6.9 );
        System.assertEquals(poke.Altura__c,0.7 );
    }
}
