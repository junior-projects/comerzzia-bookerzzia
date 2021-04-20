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
<!-- para qué es la @? -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="cmz" uri="http://comerzzia.com/taglib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!-- Añado la otra librería de la que se habla en el vídeo?? -->

<!-- useBean? qué es un Bean por cierto? por qué llamamos a alguna clases Bean en los modelos? -->
<%-- <jsp:useBean id="paramBuscarLenguajes" type="com.comerzzia.core.persistencia.usuarios.ParametrosBuscarUsuariosBean" scope="session" /> --%>
<jsp:useBean id="paramBuscarLenguajes" type="com.comerzzia.bookerzzia.backoffice.services.lenguajes.ParametrosBuscarLenguajesBean" scope="session" />
<jsp:useBean id="paginaResultados" class="com.comerzzia.core.util.paginacion.PaginaResultados" scope="request" />
<jsp:useBean id="permisos" class="com.comerzzia.core.servicios.permisos.PermisosEfectivosAccionBean" scope="request" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Comerzzia</title>
    
    <cmz:head/>
    <script type="text/javascript" language="javascript" src="comun/js/comun.js"></script>
    <script type="text/javascript" language="javascript" src="comun/js/formulario.js"></script>
    
    <!-- está bien aquí codlengua? -->
    <script type="text/javascript">
        function inicio() {
        	setFoco("codlengua");
        }
    </script>
  </head>

<!-- Permisos, esta parte debe ser común a todos los jsp -->
  <body onload="inicio();">
    <cmz:main>
      <cmz:panelCMZ>
        <cmz:cabeceraPanelCMZ titulo="${permisos.accionMenu.titulo}" icono="${permisos.accionMenu.icono}">
          <cmz:acciones numAccionesVisibles="1">
            <c:if test="${permisos.puedeAñadir}">
			  <cmz:accionNuevoRegistro onclick="alta()" descripcion="Añadir un nuevo lenguaje"/>	            
            </c:if>
            <cmz:accion titulo="Ver Permisos" icono="comun/images/iconos/i-key.gif" descripcion="Ver permisos efectivos del usuario" onclick="verPermisos(${permisos.accionMenu.idAccion})" />
            <c:if test="${permisos.puedeAdministrar}">
              <cmz:accion titulo="Administrar Permisos" icono="comun/images/iconos/i-admin_permisos.gif" descripcion="Administración de permisos" onclick="adminPermisos(${permisos.accionMenu.idAccion})" />
            </c:if>
          </cmz:acciones>
        </cmz:cabeceraPanelCMZ>
        
        <cmz:cuerpoPanelCMZ>
          <cmz:mensaje/>
          <!-- action lenguajes -->
          <form id="frmDatos" name="frmDatos" action="lenguajes" method="post">
            <input id="accion" name="accion" type="hidden" value="" />
            <input id="operacion" name="operacion" type="hidden" value="" />
            <input id="columna" name="columna" type="hidden" value="" />
            <input id="pagina" name="pagina" type="hidden" value="" />
            <input id="idObjeto" name="idObjeto" type="hidden" value="" />
            
            <!-- Panel con los filtros que se quieren aplicar a la búsqueda -->
            <cmz:panel>
              <cmz:cabeceraPanel titulo="Búsqueda de Lenguajes"></cmz:cabeceraPanel>
              <cmz:cuerpoPanel>
                <table cellpadding="0px" cellspacing="0px" border="0px">
                  <tr>
                    <td>
                      <table cellpadding="2px" cellspacing="2px" border="0px">
                        <tr>
                          <td><cmz:etiqueta titulo="Código"/>:</td>
                          <td><cmz:campoTexto id="codlengua" valor="${paramBuscarLenguajes.codlengua}" anchura="350px" longitudMaxima="100"/></td>

<!--                           <td> -->
<!--       						<select class="campo" id="activo" name="activo"> -->
<%--                           		<option value="" <c:if test="${paramBuscarUsuarios.activo == ''}">selected="selected"</c:if>><cmz:etiqueta titulo="Todos"/></option> --%>
<%--                           		<option value="S" <c:if test="${paramBuscarUsuarios.activo == 'S'}">selected="selected"</c:if>><cmz:etiqueta titulo="Activos"/></option> --%>
<%--                           		<option value="N" <c:if test="${paramBuscarUsuarios.activo == 'N'}">selected="selected"</c:if>><cmz:etiqueta titulo="Inactivos"/></option> --%>
<!--                           	</select> -->
<!--                           </td> -->
                        
                          <!-- Separador del botón -->
                          <td width="150px"></td>
		                  
		                  <td>
		                  <!-- botón consultar que ejecuta la búsqueda -->
	                        <cmz:botonConsultar onclick="consultar();"/>
	                      </td>
                        </tr>
                        
                        <tr>
                          <td><cmz:etiqueta titulo="Descripción"/>:</td>
                          <td><cmz:campoTexto id="desLengua" valor="${paramBuscarLenguajes.deslengua}" anchura="350px" longitudMaxima="50"/></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </cmz:cuerpoPanel>
            </cmz:panel>
            
            <!-- Panel que muestra una tabla con los resultados de la búsqueda -->
            <c:choose>
              <c:when test="${paginaResultados.pagina != null}">
                <cmz:panel>
                  <cmz:cabeceraPanelResultados numPorPagina="${paginaResultados.tamañoPagina}"></cmz:cabeceraPanelResultados>
                  <cmz:cuerpoPanel>
                    <cmz:listaPaginada>
                      <cmz:cabeceraListaPaginada ordenActual="${paramBuscarLenguajes.orden}">
                        <cmz:itemCabeceraListaPaginada nombre="Código" columna="1" ordenColumna="CODLENGUA"></cmz:itemCabeceraListaPaginada>
                        <cmz:itemCabeceraListaPaginada nombre="Descripción" columna="2" ordenColumna="DESLENGUA"></cmz:itemCabeceraListaPaginada>
                        <cmz:itemCabeceraListaPaginada nombre="Acciones" estilo="text-align: center;"></cmz:itemCabeceraListaPaginada>
                      </cmz:cabeceraListaPaginada>
                      <cmz:contenidoListaPaginada variable="lenguaje" paginaResultados="${paginaResultados}">
                        <cmz:itemContenidoListaPaginada valor="${lenguaje.codlengua}" onclick="ver('${lenguaje.codlengua}');"></cmz:itemContenidoListaPaginada>
                        <cmz:itemContenidoListaPaginada valor="${lenguaje.deslengua}"></cmz:itemContenidoListaPaginada>
                        <cmz:acciones alineacion="center">
                          <cmz:accion icono="comun/images/iconos/i-busca.gif" onclick="ver('${lenguaje.codlengua}');" descripcion="Ver Usuario"></cmz:accion>
                          <c:if test="${permisos.puedeEditar}">
                            <cmz:accion icono="comun/images/iconos/i-edit.gif" onclick="editar('${lenguaje.codlengua}');" descripcion="Editar Usuario"></cmz:accion>
                          </c:if>
                          <c:if test="${permisos.puedeEliminar}">
                            <cmz:accion icono="comun/images/iconos/i-cancel.gif" onclick="eliminar('${lenguaje.codlengua}');" descripcion="Eliminar Usuario"></cmz:accion>
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