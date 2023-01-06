public class PokemonCard {
  @Auraenabled(cacheable=true)
    public static List<Pokemon__c> getPokemons() {
        return [
            SELECT Id, Name, Tipos__c, Altura__c, Peso__c, Generacion__c, Imagen__c, ExtId__c
            FROM Pokemon__c ORDER BY ExtId__c
        ];
    }
}
