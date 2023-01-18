public class PokemonCard {
  @Auraenabled(cacheable=true)
    public static List<Pokemon__c> buscarPokemons() {
        return [
            SELECT Id, Name, Tipos__c,Generacion__c, Imagen__c, ExtId__c
            FROM Pokemon__c ORDER BY ExtId__c
        ];
    }
  @Auraenabled(cacheable=true)
    public static List<Pokemon__c> buscarTipo(String tipo) {
        if (String.isBlank(tipo)) {
            return buscarPokemons();
        }else {
            return [
                SELECT Id, Name, Tipos__c, Generacion__c, Imagen__c, ExtId__c
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
                SELECT Id, Name, Tipos__c,Generacion__c, Imagen__c, ExtId__c
                FROM Pokemon__c
                WHERE Generacion__c = :generacion
                ORDER BY ExtId__c
            ];
        }
    }

    @Auraenabled(cacheable=true)
    public static List<Pokemon__c> searchThis(String search) {
        String search1 = '%' + search + '%';
        if (String.isBlank(search)) {
            return buscarPokemons();
        }else{
            return [
            SELECT Name, Tipos__c,Generacion__c, Imagen__c, ExtId__c
            FROM Pokemon__c
            WHERE Name LIKE :search1
            ORDER BY ExtId__c
            ];
        }
    }
       
}