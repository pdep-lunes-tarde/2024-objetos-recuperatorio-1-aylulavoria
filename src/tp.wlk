object prueba {}


/* Puse las clases en mayúscula porque wollok me muestra un warning sino. Aviso porque leí la corrección del parcial anterior sobre que tenían que estar en minúscula */
class ProblemaDeMiembros inherits DomainException{}
class ElementoMagico{
    var poderBase

    method poderTotal(nombreMago)
}
class Varita inherits ElementoMagico{
    var poderTot

    override method poderTotal(mago){
        if (mago.nombre().even()){
            poderTot = poderBase + ((poderBase*50)/100)
            
        }else{
            poderTot = poderBase
        }
    
        return poderTot

    }
}
class Tunica inherits ElementoMagico{
    var poderTot

    override method poderTotal(mago){
        poderTot = mago.resistencia() * 2
        return poderTot
    }
}

class TunicaEpica inherits Tunica{
    override method poderTotal(mago){
        poderTot = (mago.resistencia() * 2) + 10
        return poderTot
    }
    
}
class Amuleto inherits ElementoMagico{
    const poderTot = 200
}

object ojotaMagica{
    const unidadesFijasPoder = 10
    method poderTotal(mago){
        mago.nombre().size() * unidadesFijasPoder
    }
}
class Mago{
    var nombre
    var poderInnato
    var objetosEquipados = []
    var resistenciaMagica
    var property energiaMagica
    method poderTotal(){
        (objetosEquipados.filter({objeto => objeto.poder()}).sum()) * poderInnato
    }
    
    method esVencido(magoDefensor,magoAtacante)
    method cederPuntos(mago1,mago2)


    method desafiarMago(mago1,mago2){
        self.esVencido(mago1,mago2)
    }
}

class Aprendiz inherits Mago{

    override method esVencido(magoDefensor,magoAtacante){
        magoDefensor.resistenciaMagica() < magoAtacante.poderTotal(magoAtacante)
    }
    override method cederPuntos(magoDefensor,magoAtacante){
        var energiaFinalGanador
        energiaFinalGanador = magoAtacante.energiaMagica() + (magoDefensor.energiaMagica()/2)
        magoAtacante.energiaMagica(energiaFinalGanador)
        magoDefensor.energiaMagica(magoDefensor.energiaMagica()/2)
    }
}

class Veterano inherits Mago{
    override method esVencido(magoVeterano, magoAtacante){
        if (magoAtacante.poderTotal(magoAtacante) == 1.5 * magoVeterano.resistencia()){
            magoVeterano.cederPuntos(magoVeterano,magoAtacante)
        }
    }

    override method cederPuntos(magoDefensor, magoAtacante){
        var energiaFinalGanador
        energiaFinalGanador = magoAtacante.energiaMagica() + (magoDefensor.energiaMagica()* 0.25)
        magoAtacante.energiaMagica(energiaFinalGanador)
        magoDefensor.energiaMagica(magoDefensor.energiaMagica() - (magoDefensor.energiaMagica()*0.25))
    }
}
class Inmortal inherits Mago{
    override method cederPuntos(magoDefensor,magoAtacante){}
    override method esVencido(magoDefensor,magoAtacante){
        return false
    }
}

const magoAprendiz = new Aprendiz(nombre = "pepito", poderInnato = 1, objetosEquipados = [varitaSimpleDePepito], resistenciaMagica = 3, energiaMagica = 6)
const magoVeterano = new Veterano(nombre = "Gandalf", poderInnato = 8, objetosEquipados = [tunicaEpicaDeGandalf],resistenciaMagica = 10, energiaMagica = 18)

const varitaSimpleDePepito = new Varita(poderTot = 6,poderBase = 6)
const tunicaEpicaDeGandalf = new TunicaEpica(poderTot=30, poderBase = 20)

  /* magoAprendiz.desafiarMago(magoAprendiz, magoVeterano) */

class Gremio {
    var poderGremio
    var energiaMagica
    var integrantesDelGremio

    method crearGremio(listadoDeMagos){
        if (listadoDeMagos >2 && listadoDeMagos.forEach({mago1,mago2 => mago1 != mago2})){
            integrantesDelGremio.addAll(listadoDeMagos)
        }else{
            throw new ProblemaDeMiembros(message= "No se puede crear el gremio. Revise los integrantes")
        }

    }
    method agregarMiembro(magoNuevo){
        
        integrantesDelGremio.add(magoNuevo)

    }

    method energiaGremio(){
        integrantesDelGremio.forEach({miembro =>miembro.poderTotal()}).sum()
    }

    method reservaDeEnergiaMagica(){
        integrantesDelGremio.forEach({miembro => miembro.energiaMagica()}).sum()
    }

    method esLider(){
        return integrantesDelGremio.filter({miembro => miembro.poderTotal(miembro).max()})
         
    }
    method esVencidoGremio(gremio,adversario){
       return adversario.poderTotal(adversario.nombre()) > (integrantesDelGremio.forEach({miembro => miembro.resistenciaMagica()}).sum() + gremio.esLider().poderTotal(adversario))
    }

    method ganarEnergiaMagica(gremio, adversario){
        const liderDelGremio = gremio.esLider()
        if(self.esVencidoGremio(gremio, adversario)){
        adversario.cederPuntos(adversario, liderDelGremio)
        }
    }

    method desafiar(gremio, adversario){
        self.esVencidoGremio(gremio,adversario)
    }
}

const gremio1 = new Gremio(poderGremio = 15, energiaMagica = 24 , integrantesDelGremio = [magoAprendiz, magoVeterano])
const magoInmortal = new Inmortal(nombre = "inmortal", poderInnato = 10, objetosEquipados = [], resistenciaMagica = 1000, energiaMagica = 18)


/* gremio.desafiar(gremio1, magoInmortal) */

/* punto 3. Deberia poderse. La manera en la que está modelado para hallar al lider es filtrar por el miembro mas poderoso del gremio, por lo que si hay mas de 1 lider, devuelve todos */