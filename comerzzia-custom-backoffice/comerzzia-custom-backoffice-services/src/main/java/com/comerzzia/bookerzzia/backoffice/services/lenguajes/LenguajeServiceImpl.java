package com.comerzzia.bookerzzia.backoffice.services.lenguajes;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.comerzzia.bookerzzia.backoffice.persistence.lenguajes.Lenguaje;
import com.comerzzia.bookerzzia.backoffice.persistence.lenguajes.LenguajeExample;
import com.comerzzia.bookerzzia.backoffice.persistence.lenguajes.LenguajeKey;
import com.comerzzia.bookerzzia.backoffice.persistence.lenguajes.LenguajeMapper;
import com.comerzzia.bookerzzia.backoffice.persistence.lenguajes.ParametrosBuscarLenguajesBean;
import com.comerzzia.bookerzzia.backoffice.persistence.lenguajes.LenguajeExample.Criteria;
import com.comerzzia.core.servicios.sesion.DatosSesionBean;
import com.comerzzia.core.servicios.sesion.IDatosSesion;
import com.comerzzia.core.util.base.Estado;
import com.comerzzia.core.util.paginacion.PaginaResultados;

import jxl.common.Logger;

@Service
public class LenguajeServiceImpl implements ILenguajeService {

	protected static Logger log = Logger.getLogger(LenguajeServiceImpl.class);

	@Autowired
	LenguajeMapper lenguajeMapper;

	// la consulta por parámetros devuelve una PaginaResultados
	// necesita que le demos un objeto que herede de la clase ParametrosBuscarBean
	@Override
	public PaginaResultados consultar(ParametrosBuscarLenguajesBean lenguajeParameters, IDatosSesion datosSesion) throws LenguajeException {
		log.debug("consultar() - Consultando lenguajes");

		LenguajeExample lenguajeExample = new LenguajeExample();

		// para construir los where con mybatis usamos la clase Criteria que es una clase estática
		// que crea Mybatis con cada modelo en la parte Example
		// or() == createCriteria()
		// importar Criteria del modelo
		Criteria criteria = lenguajeExample.or().andUidInstanciaEqualTo(datosSesion.getUidInstancia());

		// CODLENGUA

		if (StringUtils.isNotBlank(lenguajeParameters.getCodLengua())) {
			criteria.andCodlenguaLikeInsensitive("%" + lenguajeParameters.getCodLengua() + "%");
		}

		// DESLENGUA
		if (StringUtils.isNotBlank(lenguajeParameters.getDesLengua())) {
			criteria.andCodlenguaLikeInsensitive("%" + lenguajeParameters.getDesLengua() + "%");
		}

		lenguajeExample.setOrderByClause(lenguajeParameters.getOrden());
		if (lenguajeParameters.getNumPagina() == 0) {
			lenguajeParameters.setNumPagina(1);
		}

		// array que contiene objetos Lenguaje, el tamaño del array es el tamaño de la página
		// que es lo mismo que el número de resultados por página
		List<Lenguaje> resultados = new ArrayList<Lenguaje>(lenguajeParameters.getTamañoPagina());

		// PaginaResultados usa la clase anterior (resultados por página) y además
		// una clase con los atributos de Lenguaje + atributos tamañoPagina, numPagina y orden
		PaginaResultados paginaResultados = new PaginaResultados(lenguajeParameters, resultados); // TODO porqué no instanciamos un ParametrosBuscarLenguajesBean?

		// todos los lenguajes
		List<Lenguaje> lenguajes = lenguajeMapper.selectByExample(lenguajeExample);

		// no sé cómo funciona esto pero creo que setea los índices en función del nº de lenguajes que hay
		Integer fromIndex = paginaResultados.getInicio() - 1;
		Integer toIndex = paginaResultados.getInicio() + paginaResultados.getTamañoPagina() - 1;
		if (toIndex > lenguajes.size()) {
			toIndex = lenguajes.size();
		}

		// añade, a los resultados una sublista, dependiendo de cómo se hayan seteado los índices.
		resultados.addAll(lenguajes.subList(fromIndex, toIndex));

		// el componente JSP utiliza esta clase para mostrar los resultados
		paginaResultados.setTotalResultados(lenguajes.size());
		return paginaResultados;
	}

	// consulta por clave primaria
	@Override
	public Lenguaje consultar(String codLengua, IDatosSesion datosSession) throws LenguajeNotFoundException, LenguajeException {

		log.debug("consultar() - consultando lenguaje con código: " + codLengua);

		try {
			// se crea el objeto que representa la clave primaria
			LenguajeKey lenguajeKey = new LenguajeKey();
			lenguajeKey.setUidInstancia(datosSession.getUidInstancia());
			lenguajeKey.setCodlengua(codLengua);

			// se hace la consulta usando el mapper y se le pasa el objeto-clave primaria
			Lenguaje lenguaje = lenguajeMapper.selectByPrimaryKey(lenguajeKey);

			// control de errores
			if (lenguaje == null) {
				String msg = "No se ha encontrado el lenguaje";
				log.info("consultar() - " + msg);
				throw new LenguajeNotFoundException(msg);
			}

			return lenguaje;
		}
		catch (LenguajeNotFoundException e) {
			throw e;
		}
		catch (Exception e) {
			// captura cualquier otra excepción que pueda ocurrir
			String msg = "Ha ocurrido un error consultando el lenguaje"; // mensaje personalizado
			log.error(msg + ": " + e.getMessage()); // capturamos el mensaje de error de la excepción que sea

			throw new LenguajeException(msg, e); // lanzamos nuestra excepción con el msg y el mensaje de la causa del
			                                     // error

		}

	}

	@Override
	public void salvar(Lenguaje lenguaje, IDatosSesion datosSession) throws LenguajeException {

		switch (lenguaje.getEstadoBean()) {
			case Estado.NUEVO:

				crear(lenguaje, datosSession);
				break;
			case Estado.MODIFICADO:
				modificar(lenguaje, datosSession);
				break;

		}
	}

	@Override
	public void crear(Lenguaje lenguaje, IDatosSesion datosSesion) throws LenguajeException {
		log.debug("crear() - creando nuevo lenguaje");

		try {
			lenguaje.setUidInstancia(datosSesion.getUidInstancia());
			lenguajeMapper.insert(lenguaje);
		}
		catch (Exception e) {

			String message = "crear() - no se ha podido crear lenguaje";
			log.error(message);
			throw new LenguajeException(message, e);
		}

	}

	@Override
	public void modificar(Lenguaje lenguaje, IDatosSesion datosSesion) throws LenguajeException {

		log.debug("modificar() - modificando lenguaje: " + lenguaje.getDeslengua());

		try {
			lenguaje.setUidInstancia(datosSesion.getUidInstancia());
			lenguajeMapper.updateByPrimaryKey(lenguaje); // TODO cómo sabe aquí que el objeto lenguaje un LenguajeKey ??? de hecho no lo es no?
			// Lenguaje es una subclase de LenguajeKey. Por lo que podremos usar updateByPrimaryKey
		}
		catch (Exception e) {
			String msg = "No se ha podido modificar lenguaje";
			log.error(msg + ":" + e.getMessage()); // en el log mostramos tanto nuestro mensaje personalizado como el
			throw new LenguajeException(msg,e);
		}

	}

	@Override
	public void eliminar(String codLenguaje, IDatosSesion datosSesion) throws LenguajeException {
		log.debug("eliminar() - eliminando lenguaje: " + codLenguaje);

		try {
			LenguajeKey key = new LenguajeKey();
			key.setUidInstancia(datosSesion.getUidInstancia());
			key.setCodlengua(codLenguaje);
			lenguajeMapper.deleteByPrimaryKey(key); // by primary key??
		}
		catch (Exception e) {
			String msg = "No se ha podido eliminar lenguaje";
			log.error(msg + ":" + e.getMessage());
			throw new LenguajeException(msg, e); // mostrará tanto el mensaje como la causa del error
		}

	}

}
