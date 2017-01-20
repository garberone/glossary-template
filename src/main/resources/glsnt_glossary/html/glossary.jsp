<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="s" uri="http://www.jahia.org/tags/search" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<template:addResources type="css" resources="tooltips.css" />
<template:addResources type="javascript" resources="jquery.min.js, tooltips.js"/>

<c:url value="${url.base}${docPath}${renderContext.mainResource.node.path}" var="currentNodePath"/>
<jcr:node var="glossarySettings" path="${renderContext.site.path}/glossarySettings"/>
<c:set var="glossaryPath" value="${glossarySettings.properties['pathTxt'].string}"/>
<c:set var="glossaryUrl" value="${url.base}${glossarySettings.properties['pathTxt'].string}"/>

${currentNode.properties['documentation'].string}

<template:addResources>
    <script type="text/javascript">
        $(document).ready(function () {
            glossaryArray = $('.gloss');

            for (idx = 0, len = glossaryArray.length; idx < len; ++idx) {
                var htmlObj = glossaryArray[idx];
                var str = htmlObj.innerHTML;
                var word = str.toLowerCase();
                var path = '${glossaryUrl}'+ ".html#";
                var actionUrl  = '${currentNodePath}.Glossary.do?path=${glossaryPath}&keyword=' + word;

                $.ajax({
                    type: 'GET',
                    url: actionUrl,
                    dataType: 'json',
                    success: function(data) {
                        if (typeof data.description == "undefined" || !(word === data.keyword)) {
                            console.log("keyword :" + word + ", is not defined in the dictionary");
                        }else{
                            var description = str + ": " + data.description;
                            var newStr = "\<\a title= \"" + description + "\" href=\"" + path + word + "\">" + str + "</a>";
                            htmlObj.innerHTML = newStr;
                        }
                    },
                    data: {},
                    async: false
                });
            }

            $("#page-wrap a[title]").tooltips();

        });
    </script>
</template:addResources>