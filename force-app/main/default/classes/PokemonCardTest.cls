@isTest
public class PokemonCardTest {
    @isTest static void debeMostrarPokemon() {
        
        // Inserta datos de prueba
        insert new Pokemon__c(Name='Charmander',Imagen__c='https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png',ExtId__c=4);
        List<Pokemon__c> pokemons = PokemonCard.buscarPokemons();
        
        System.assertEquals(1, pokemons.size());
        // Verifica si los datos son correctos
        System.assertEquals('Charmander', pokemons[0].Name);
        System.assertEquals('https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png',pokemons[0].Imagen__c);
        System.assertEquals(4,pokemons[0].ExtId__c);
    }
    
    @isTest static void noDebeMostrarPokemon() {
        
        //Intenta buscar pokemons con una consulta mal formada
        List<Pokemon__c> pokemons = PokemonCard.buscarPokemons();
        
        System.assertEquals(0, pokemons.size());
    }
    
    @isTest static void debeBuscarTipo() {
        
        insert new Pokemon__c(Name='Pikachu', Tipos__c='Electric', ExtId__c=25);
               
        // Llama al método buscarTipo con el tipo "Electric"
        List<Pokemon__c> pokemons = PokemonCard.buscarTipo('Electric');
        
        System.assertEquals(1, pokemons.size());
        
        // Verifica si el pokemon es correcto
        System.assertEquals('Pikachu', pokemons[0].Name);
        System.assertEquals('Electric', pokemons[0].Tipos__c);
        System.assertEquals(25,pokemons[0].ExtId__c);
    }
    @isTest static void noDebeBuscarTipo() {
        // Llama al método buscarTipo con un tipo vacío
        List<Pokemon__c> pokemons = PokemonCard.buscarTipo('');
        
        System.assertEquals(0, pokemons.size());
    }
    
    @isTest static void debeBuscarGen() {
        
        insert new Pokemon__c(Name='Pikachu', Tipos__c='Electric',ExtId__c=25);
        
        // Llama al método buscarGen con la generacion 1
        List<Pokemon__c> pokemons = PokemonCard.buscarGen(1);
        
        System.assertEquals(1, pokemons.size());
        // Verifica si el pokemon es correcto
        System.assertEquals('Pikachu', pokemons[0].Name);
         System.assertEquals('Electric', pokemons[0].Tipos__c);
        
    }
    @isTest static void DebeBuscarGenCero() {
        
        List<Pokemon__c> pokemons = PokemonCard.buscarGen(0);
        
        System.assertEquals(0, pokemons.size());
    }
    
      @isTest static void NoDebeBuscarGen() {
        
        List<Pokemon__c> pokemons = PokemonCard.buscarGen(-1);
        
        System.assertEquals(0, pokemons.size());
    }
    
    
    @isTest static void debeBuscarPorLetras() {
        
        insert new Pokemon__c(Name='Pikachu', Tipos__c='Electric',ExtId__c=25);
       
        // Llama al método searchThis con la search "Pik"
        List<Pokemon__c> pokemons = PokemonCard.searchThis('Pik');
      
        System.assertEquals(1, pokemons.size());
        System.assertEquals('Pikachu', pokemons[0].Name);
    }
    @isTest static void noDebeBuscarPorLetras() {
        // Llama al método searchThis con un string vacio
        List<Pokemon__c> pokemons = PokemonCard.searchThis('');
       System.assertEquals(0, pokemons.size());
    }
}