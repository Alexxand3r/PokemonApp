import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import buscarPokemons from '@salesforce/apex/PokemonCard.buscarPokemons';
import buscarTipo from '@salesforce/apex/PokemonCard.buscarTipo';
import buscarGen from '@salesforce/apex/PokemonCard.buscarGen';
import searchThis from '@salesforce/apex/PokemonCard.searchThis';

export default class VisualizarRegistros extends NavigationMixin(LightningElement) {
    @track data;
    @track tipo = '';
    @track generacion = '';
    search;
    get opcionesTipo() {
        return [
            { label: 'Todos', value: '' },
            { label: 'Normal', value: 'Normal' },
            { label: 'Luchador', value: 'Fighting' },
            { label: 'Volador', value: 'Flying' },
            { label: 'Veneno', value: 'Poison' },
            { label: 'Tierra', value: 'Ground' },
            { label: 'Piedra', value: 'Rock' },
            { label: 'Insecto', value: 'Bug' },
            { label: 'Fantasma', value: 'Ghost' },
            { label: 'Acero', value: 'Steel' },
            { label: 'Fuego', value: 'Fire' },
            { label: 'Agua', value: 'Water' },
            { label: 'Hierba', value: 'Grass' },
            { label: 'Electrico', value: 'Electric' },
            { label: 'Psiquico', value: 'Psychic' },
            { label: 'Dragon', value: 'Ice' },
            { label: 'Dragon', value: 'Dragon' },
            { label: 'Oscuro', value: 'Dark' },
            { label: 'Hada', value: 'Fairy' },
        ];
    }
    get opcionesGen() {
        return [
            { label: 'todos', value: 0 },
            { label: '1ra Gen', value: 1 },
            { label: '2da Gen', value: 2 },
            { label: '3ra Gen', value: 3 },
            { label: '4ta Gen', value: 4 },
            { label: '5ta Gen', value: 5 },
            { label: '6ta Gen', value: 6 },
            { label: '7ma Gen', value: 7 },
            { label: '8va Gen', value: 8 },
        ];
    }
    connectedCallback(){
        buscarPokemons().then(data => {
            this.data = data;
        }).catch(err => {
            console.log('Error');
        })
    }
    handleTypeChange(event){
        this.tipo = event.detail.value;
        buscarTipo({tipo : this.tipo}).then(data => {
            this.data = data;
        }).catch(err => {
            console.log('Error en tipos.');
        })
    }
    handleGenChange(event){
        this.generacion = event.detail.value;
        buscarGen({generacion : this.generacion}).then(data => {
            this.data = data;
        }).catch(err => {
            console.log('Error en generaciones.');
        })
    }
    handleClick(event){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.currentTarget.dataset.id,
                objectApiName: 'Pokemon__c',
                actionName: 'view'
            }
        });
    }
    handleSearch(event){
        this.search = event.detail.value;
        searchThis({search : this.search}).then(data => {
            this.data = data;
        }).catch(err => {
            console.log('Error.');
        })
    }
}