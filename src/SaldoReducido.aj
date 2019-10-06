import java.util.List;

import ejemplo.cajero.control.Comando;
import ejemplo.cajero.control.ComandoConsignar;
import ejemplo.cajero.modelo.Cuenta;

public aspect SaldoReducido {
	// TODO Auto-generated aspect
	//el point cut es el punto donde agrego los comandos
	pointcut operacionesCuenta(Cuenta c, long v): target(c) && args(v) && call(* ejemplo.cajero.modelo.Cuenta.retirar(..));
	
	Object around(Cuenta c, long v) : operacionesCuenta(c, v) {
		
		if((c.getSaldo() - v) < 200) {
			System.out.println("Error: valor a retirar excede el saldo reducido");
			return null;
		} 
		Object result  = proceed(c, v);
		return result;
	}
}