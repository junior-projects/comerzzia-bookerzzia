package com.comerzzia.bookerzzia.backoffice.persistence.lenguajes;


import com.comerzzia.core.util.base.ParametrosBuscarBean;

public class ParametrosBuscarLenguajesBean extends ParametrosBuscarBean { // ojo herencia de ParametrosBuscarbean

	private String codLengua;
	private String desLengua;


	public String getCodLengua() {
		return codLengua;
	}

	public void setCodLengua(String codLengua) {
		this.codLengua = codLengua;
	}

	public String getDesLengua() {
		return desLengua;
	}

	public void setDesLengua(String desLengua) {
		this.desLengua = desLengua;
	}

	

}
