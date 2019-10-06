import java.util.List;

import ejemplo.cajero.control.Comando;
import ejemplo.cajero.control.ComandoTransferir;

public aspect Transferencias {
	// TODO Auto-generated aspect
	//el point cut es el punto donde agrego los comandos
	pointcut cargaDeComandos(): call(* ejemplo.cajero.Cajero.cargaComandos(..));
	
	Object around() : cargaDeComandos() {
		Object result = proceed();
		//agregar el comando al listado de comandos
		List<Comando> comandos = (List<Comando>)result;
		comandos.add(new ComandoTransferir());
		return comandos;
	}
}