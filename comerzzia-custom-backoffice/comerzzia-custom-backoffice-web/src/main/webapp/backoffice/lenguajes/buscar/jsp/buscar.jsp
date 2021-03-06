<%--

    ComerZZia 3.0

    Copyright (c) 2008-2015 Comerzzia, S.L.  All Rights Reserved.

    THIS WORK IS  SUBJECT  TO  SPAIN  AND  INTERNATIONAL  COPYRIGHT  LAWS  AND
    TREATIES.   NO  PART  OF  THIS  WORK MAY BE  USED,  PRACTICED,  PERFORMED
    COPIED, DISTRIBUTED, REVISED, MODIFIED, TRANSLATED,  ABRIDGED, CONDENSED,
    EXPANDED,  COLLECTED,  COMPILED,  LINKED,  RECAST, TRANSFORMED OR ADAPTED
    WITHOUT THE PRIOR WRITTEN CONSENT OF COMERZZIA, S.L. ANY USE OR EXPLOITATION
    OF THIS WORK WITHOUT AUTHORIZATION COULD SUBJECT THE PERPETRATOR TO
    CRIMINAL AND CIVIL LIABILITY.

    CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON ADDITIONAL
    RESTRICTIONS.

--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="cmz" uri="http://comerzzia.com/taglib"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:useBean id="paramBuscarLenguajes"
	type="com.comerzzia.bookerzzia.backoffice.persistence.lenguajes.ParametrosBuscarLenguajesBean"
	scope="session" />
<jsp:useBean id="paginaResultados"
	class="com.comerzzia.core.util.paginacion.PaginaResultados"
	scope="request" />
<jsp:useBean id="permisos"
	class="com.comerzzia.core.servicios.permisos.PermisosEfectivosAccionBean"
	scope="request" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Comerzzia</title>

<cmz:head />
<script type="text/javascript" language="javascript"
	src="comun/js/comun.js"></script>
<script type="text/javascript" language="javascript"
	src="comun/js/formulario.js"></script>
<script type="text/javascript" language="javascript"
	src="comun/js/ayudas.js"></script>

<script type="text/javascript">
        function inicio() {
        	setFoco("codlengua");
        }
    </script>
</head>

<body onload="inicio();">
	<cmz:main>
		<cmz:panelCMZ>
			<cmz:cabeceraPanelCMZ titulo="${permisos.accionMenu.titulo}"
				icono="${permisos.accionMenu.icono}">
				<cmz:acciones numAccionesVisibles="1">
					<c:if test="${permisos.puedeA??adir}">
						<cmz:accionNuevoRegistro onclick="alta()"
							descripcion="Alta de un nuevo lenguaje" />
					</c:if>
					<cmz:accion titulo="Ver Permisos"
						icono="comun/images/iconos/i-key.gif"
						descripcion="Ver permisos efectivos del usuario"
						onclick="verPermisos(${permisos.accionMenu.idAccion})" />
					<c:if test="${permisos.puedeAdministrar}">
						<cmz:accion titulo="Administrar Permisos"
							icono="comun/images/iconos/i-admin_permisos.gif"
							descripcion="Administraci??n de permisos"
							onclick="adminPermisos(${permisos.accionMenu.idAccion})" />
					</c:if>
				</cmz:acciones>
			</cmz:cabeceraPanelCMZ>

			<cmz:cuerpoPanelCMZ>
				<cmz:mensaje />
				<form id="frmDatos" name="frmDatos" action="lenguajes" method="post">
					<input id="accion" name="accion" type="hidden" value="" /> <input
						id="operacion" name="operacion" type="hidden" value="" /> <input
						id="columna" name="columna" type="hidden" value="" /> <input
						id="pagina" name="pagina" type="hidden" value="" /> <input
						id="idObjeto" name="idObjeto" type="hidden" value="" />

					<cmz:panel>
						<cmz:cabeceraPanel titulo="B??squeda de Lenguajes"></cmz:cabeceraPanel>
						<cmz:cuerpoPanel>
							<table cellpadding="0px" cellspacing="0px" border="0px">
								<tr>
									<td>
										<table cellpadding="2px" cellspacing="2px" border="0px">
											<tr>
												<td><cmz:etiqueta titulo="C??digo" />:</td>
												<td><cmz:campoTexto id="codlengua"
														valor="${paramBuscarLenguajes.codlengua}" anchura="100px"
														longitudMaxima="6" /></td>


												<!-- Separador del bot??n -->
												<td width="50px"></td>

												<td><cmz:botonConsultar onclick="consultar();" /></td>
											</tr>

											<tr>
												<td><cmz:etiqueta titulo="Descripci??n" />:</td>
												<td><cmz:campoTexto id="deslengua"
														valor="${paramBuscarLenguajes.deslengua}" anchura="100px"
														longitudMaxima="20" /></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</cmz:cuerpoPanel>
					</cmz:panel>

					<c:choose>
						<c:when test="${paginaResultados.pagina != null}">
							<cmz:panel>
								<cmz:cabeceraPanelResultados
									numPorPagina="${paginaResultados.tama??oPagina}"></cmz:cabeceraPanelResultados>
								<cmz:cuerpoPanel>
									<cmz:listaPaginada>
										<cmz:cabeceraListaPaginada
											ordenActual="${paramBuscarLenguajes.orden}">
											<cmz:itemCabeceraListaPaginada nombre="C??digo" columna="1"
												ordenColumna="CODLENGUA"></cmz:itemCabeceraListaPaginada>
											<cmz:itemCabeceraListaPaginada nombre="Descripci??n"
												columna="2" ordenColumna="DESLENGUA"></cmz:itemCabeceraListaPaginada>
											<cmz:itemCabeceraListaPaginada nombre="Acciones"
												estilo="text-align: center;"></cmz:itemCabeceraListaPaginada>
										</cmz:cabeceraListaPaginada>
										<cmz:contenidoListaPaginada variable="lenguaje"
											paginaResultados="${paginaResultados}">
											<cmz:itemContenidoListaPaginada valor="${lenguaje.codlengua}"
												onclick="ver('${lenguaje.codlengua}');"></cmz:itemContenidoListaPaginada>
											<cmz:itemContenidoListaPaginada valor="${lenguaje.deslengua}"></cmz:itemContenidoListaPaginada>
											<cmz:acciones alineacion="center">
												<cmz:accion icono="comun/images/iconos/i-busca.gif"
													onclick="ver('${lenguaje.codlengua}');"
													descripcion="Ver Lenguaje"></cmz:accion>
												<c:if test="${permisos.puedeEditar}">
													<cmz:accion icono="comun/images/iconos/i-edit.gif"
														onclick="editar('${lenguaje.codlengua}');"
														descripcion="Editar Lenguaje"></cmz:accion>
												</c:if>
												<c:if test="${permisos.puedeEliminar}">
													<cmz:accion icono="comun/images/iconos/i-cancel.gif"
														onclick="eliminar('${lenguaje.codlengua}');"
														descripcion="Eliminar Lenguaje"></cmz:accion>
												</c:if>
											</cmz:acciones>
										</cmz:contenidoListaPaginada>
									</cmz:listaPaginada>
								</cmz:cuerpoPanel>
							</cmz:panel>
						</c:when>
					</c:choose>
				</form>
			</cmz:cuerpoPanelCMZ>
		</cmz:panelCMZ>
	</cmz:main>
</body>
</html>