
import java.text.SimpleDateFormat;
import java.util.Date;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.reflect.CodeSignature;

import ejemplo.cajero.control.Comando;

public aspect Auditoria{
	//determinar la hora de ingreso al sistema
	pointcut ingresoCajero(): call(* ejemplo.cajero.Cajero.cargaComandos(..));
	//primero ejecuto un comando
	pointcut ejecutaComando(Comando c): target(c) && call(* ejemplo.cajero.control.Comando.ejecutar(..));
	//luego obtengo una referencia a la cuenta
	pointcut obtenerCuenta(): call(* ejemplo.cajero.modelo.Banco.buscarCuenta(..));
	//intercepto todas las operaciones sobre cuenta
	pointcut operacionesCuenta(): call(* ejemplo.cajero.modelo.Cuenta..*(..));
	
	before() : ingresoCajero() {
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");  
	    Date date = new Date();  
	    System.out.println("LOG: hora de ingreso al sistema: " + formatter.format(date));
	}
	
	before(Comando c) : ejecutaComando(c) {
		System.out.println("LOG: Se ejecuta la siguiente transaccion: " + c.getNombre());
	}
	after() : obtenerCuenta() {
		System.out.println("LOG: Se afecta la siguiente cuenta: ");
		printParameters(thisJoinPoint);
	}
	after(): operacionesCuenta(){
		System.out.println("LOG: Se realiza la siguiente operacion: " + thisJoinPoint.getSignature().getName());
		System.out.println("LOG: con el siguiente parametro: " );
		printParameters(thisJoinPoint);
	}
	
	static private void printParameters(JoinPoint jp) {
	      Object[] args = jp.getArgs();
	      String[] names = ((CodeSignature)jp.getSignature()).getParameterNames();
	      Class[] types = ((CodeSignature)jp.getSignature()).getParameterTypes();
	      for (int i = 0; i < args.length; i++) {
	    	  System.out.println(names[i] +
	             " : " +            types[i].getName() +
	             " = " +            args[i]);
	      }
	   }
}