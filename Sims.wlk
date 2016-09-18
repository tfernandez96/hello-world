class Sim
{
	var sexo
	var edad
	var nivelFelicidad 	= 0
	var amigos 			= []
	var dinero			= 0
	var conocimientos 	= #{}
	var trabajo
	var estadoDeAnimo
	var sexoPreferencia
	var pareja			= false
	var atraccion 		= []
	
	
	
	
	method valoracion(sim)
	
	method simMasValorado()
	{
		return amigos.max({amigo => self.valoracion(amigo)})
	}
	
	method estadoDeAnimo()
	{
		return estadoDeAnimo
	}
	
	method nivelFelicidad()
	{
		return nivelFelicidad
	}
	
	method dinero()
	{
		return dinero
	}
	
	method amigos()
	{
		return amigos
	}
	
	method sexo()
	{
		return sexo
	}
	
	method  popularidad ()
	{
 		return amigos.sum({sim => sim.nivelFelicidad()})
	}
	
	method conocimientos()
	{
		return conocimientos
	}
	
	method nivelFelicidad(felicidadNueva)
	{
		nivelFelicidad = felicidadNueva
	}
	
	method trabajo(trabajoNuevo)
	{
		trabajo = trabajoNuevo
	}
	
	method agregarConocimiento(unConocimiento)
	{
  		conocimientos.add(unConocimiento)
	}
	
	method eliminarConocimientos() 
	{
 		conocimientos.clear()
	}
	
	method suPreferencia(sim)
	{
		return sim.sexo() == sexoPreferencia
	}
	
	method esJoven()
	{
		return 18 <= edad <= 29
	}
	
	method masPopularQue(popularidad)
	{
		return self.popularidad() > popularidad
	}
	
	method estaTriste()
	{
		return nivelFelicidad < 200
	}
	
	method cambiarAnimo(estado)
	{
		estadoDeAnimo= estado
		estado.efectoEstadoDeAnimo(self)
	}
	
	method hacerAmigo(nuevoAmigo)
	{
		amigos.add(nuevoAmigo)
		nivelFelicidad += self.valoracion(nuevoAmigo)
		amigos.sum({sim => sim.nivelFelicidad() })
	}
	
	method trabajar()
	{
		trabajo.trabajar(self)
	}
	
	method abrazar(sim, abrazo)
	{
		abrazo.abrazar(self, sim)
	}

	
	method variarFelicidad(unaFelicidad) 
	{
 		nivelFelicidad 	+= unaFelicidad
	}

	method ganarDinero(ganancia) 
	{
 		dinero 			+= ganancia
	}

	method estaEnPareja()
	{
		return if(pareja) true
	}

	method mostrarAmigos()
	{
		return amigos
	}

	method amigosPareja()
	{
		return amigos.intersection(pareja.mostrarAmigos())
	}

	method unirPareja(otroSim)
	{
		amigos = amigos.union(otroSim.mostrarAmigos())
		pareja = otroSim
	}

	method iniciarRelacion(otroSim)
	{
		self.unirPareja(otroSim)
		otroSim.unirPareja(self)
	}

	method terminarRelacion()
	{
		if(pareja)
		{
			pareja.terminarRelacion()
		}
		pareja = false
	}

	method terminoRelacion(otroSim)
	{
		return if(pareja != otroSim)
			true
	}

	method miembrosPareja()
	{
		return (self + pareja)
	}

	method aniadirAtraccionPor(otroSim)
	{
		atraccion = atraccion.union(otroSim)
	}

	method quitarAtraccionPor(otroSim)
	{
		atraccion = atraccion.filter({x => x != otroSim})
	}

	method sienteAtraccionPor(otroSim)
	{
		return atraccion.contains(otroSim)
	}

	method relacionFunciona()
	{
		return if((self.sienteAtraccionPor(pareja)) && (pareja.sienteAtraccionPor(self)))
			true
	}

	method sePudrioTodo()
	{
		if((not(self.relacionFunciona())) && (self.sienteAtraccionPor(self.amigosPareja())))
			self.terminarRelacion()
	}

	method rehacerRelacion(exPareja)
	{
		self.terminarRelacion()
		exPareja.terminarRelacion()
		self.iniciarRelacion(exPareja)
	}

	 method	dineroDeAmigos()
 	{
 		return amigos.sum({sim => sim.dinero()})
 	}

}

class SimInteresado inherits Sim
{
	override method valoracion(sim) 
	{
  		return sim.dineroDeAmigos() * 0.1
 	}
 	
 	method leAtrae(sim)
	{
		return self.suPreferencia(sim) && self.duplicaSuFortuna(sim)
	}
	
	method duplicaSuFortuna(sim)
	{
		return sim.dinero() == self.dinero() * 2
	}
}

class SimSuperficial inherits Sim
{
	override method valoracion(sim)
	{
		return 20 * sim.popularidad()
	}
	
	method leAtrae(sim)
	{
		return sim.masPopularQue(self.mayorPopularidadDeAmigos()) && sim.esJoven() 
	}
	
	method mayorPopularidadDeAmigos()
	{
		return self.amigos().max({amigo => amigo.popularidad()})
	}
	
}

class SimBuenazo inherits Sim
{
	override method simMasValorado()
	{
		return null
	}
	
	override method valoracion(sim)
	{
		return nivelFelicidad/2
	}
	
	method leAtrae(sim)
	{
		return true
	}
}

class SimPeleado inherits Sim
{
	override method simMasValorado()
	{
		return null
	}

	override method valoracion(sim)
	{
		return 0
	}
	
	method leAtrae(sim)
	{
		return sim.estaTriste()
	}
}
