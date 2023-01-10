public class PokemonCard {
  @Auraenabled(cacheable=true)
    public static List<Pokemon__c> buscarPokemons() {
        return [
            SELECT Id, Name, Tipos__c, Altura__c, Peso__c, Generacion__c, Imagen__c, ExtId__c
            FROM Pokemon__c ORDER BY ExtId__c
        ];
    }
     @Auraenabled(cacheable=true)
    public static List<Pokemon__c> getType(String tipo) {
        if (String.isBlank(tipo)) {
            return buscarPokemons();
        }else {
            return [
                SELECT Id, Name, Tipos__c, Altura__c, Peso__c, Generacion__c, Imagen__c, ExtId__c
                FROM Pokemon__c
                WHERE Tipos__c INCLUDES (:tipo)
                ORDER BY ExtId__c
            ];
        }
    }

    @Auraenabled(cacheable=true)
    public static List<Pokemon__c> buscarGen(Integer generacion) {
        if (generacion == 0) {
            return buscarPokemons();
        }else {
            return [
                SELECT Id, Name, Tipos__c, Altura__c, Peso__c, Generacion__c, Imagen__c, ExtId__c
                FROM Pokemon__c
                WHERE Generacion__c = :generacion
                ORDER BY ExtId__c
            ];
        }
    }

    @Auraenabled(cacheable=true)
    public static List<Pokemon__c> searchThis(String search) {
        if (String.isBlank(search)) {
            return buscarPokemons();
        }else{
            search += '%';
            return [
            SELECT Name, Tipos__c, Altura__c, Peso__c, Generacion__c, Imagen__c, ExtId__c
            FROM Pokemon__c
            WHERE Name LIKE :search
            ORDER BY ExtId__c
            ];
        }
    }
}
