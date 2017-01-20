<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="uiComponents" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>

<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<jcr:node var="glossarySettings" path="${renderContext.site.path}/glossarySettings"/>
<c:set var="pathTxt" value="${glossarySettings.properties['pathTxt'].string}"/>

<template:addResources type="css" resources="bootstrap.css, glossary-template.css, folderPicker.css" />
<template:addResources type="javascript" resources="jquery.min.js"/>
<template:addResources type="javascript" resources="admin-bootstrap.js"/>
<template:addResources type="javascript" resources="jquery-ui.min.js,jquery.blockUI.js,workInProgress.js"/>
<template:addResources type="javascript" resources="GlossaryAdministrationUtils.js"/>



<template:addResources>
    <script type="text/javascript">
        var intervalValue;

        var API_URL = '${url.context}/modules/api/jcr/v1';
        var jcrPathTxt = '${functions:escapeJavaScript(pathTxt)}';


        var readUrl = API_URL + "/${renderContext.liveMode ? 'live' : 'default'}/${renderContext.UILocale}/paths${renderContext.site.path}/glossarySettings";
        <c:choose>
            <c:when test="${empty glossarySettings}">
                var mode = 'create';
                var writeUrl = API_URL + "/default/${renderContext.UILocale}/nodes/${renderContext.site.identifier}";
            </c:when>
            <c:otherwise>
                var mode = 'update';
                var writeUrl = API_URL + "/default/${renderContext.UILocale}/nodes/${glossarySettings.identifier}";
            </c:otherwise>
        </c:choose>
    </script>
</template:addResources>




<div class="clearfix">
    <h1 class="pull-left"><fmt:message key="glsnt_dictionary"/></h1>
    <div class="pull-right">
        <img alt="" src="<c:url value="${url.currentModule}/images/glossary.png"/>"
             width="90" height="32">
    </div>
</div>


<div class="container">
    <div class="box-1">
        <div class="row-fluid">
            <div class="span6">
                <form class="form-horizontal" name="glossaryParameters">
                    <fieldset>
                        <legend></legend>
                        <div class="control-group">


                            <div class="row-glossary">
                                <div class="col-md-12">
                                    <label class="label-form"> <fmt:message key="glsnt_dictionary.page"/> </label>
                                </div>
                            </div>

                            <div class="row-glossary">
                                <div class="col-md-2">
                                    <button type="button" class="btn btn-default"  onclick="callTreeView('dictionaryPathTxt')">
                                        <span class="glyphicon glyphicon-folder-open"></span>
                                        &nbsp;<fmt:message key="glsnt_dictionary.browse"/>
                                    </button>
                                </div>
                                <div class="col-md-10">
                                    <input id="dictionaryPathTxt" name="dictionaryPathTxt" readonly="true"  type="text" class="form-control"  value="${pathTxt}"/>
                                </div>
                            </div>

                        </div>
                        <div class="control-group">
                            <div class="controls">
                                <div class="col-md-12">
                                    <button id="saveGlossarySettings" type="button" class="btn btn-primary"
                                            onclick="createUpdateGlossaryParameters(intervalValue)" disabled>
                                        <fmt:message key="label.save"/>
                                    </button>
                                    <c:if test="${not empty pathTxt}">
                                        <button id="cancelGlossarySettings" type="button" class="btn btn-danger"
                                                onclick="resetGlossarySettings()" disabled>
                                            <fmt:message key="label.cancel"/>
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </fieldset>
                </form>
            </div>
            <div class="span6" style="text-align:justify">
                <div class="alert alert-info">
                    <h4><fmt:message key="glsnt_dictionary.title"/></h4>
                    <p>
                        <fmt:message key="glsnt_dictionary.description"/><br/>
                        <fmt:message key="glsnt_dictionary.version"/><br/>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>



<!-- include tree folder picker -->
<template:include view="folderPicker"  />

