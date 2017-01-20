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


<template:addResources type="css" resources="glossary-template.css" />

<div class="dictionaty-item" id="${fn:trim(fn:toLowerCase(currentNode.properties['keyword'].string))}">
  <div class="dictionary-title">
    ${currentNode.properties['keyword'].string}
  </div>

  <c:if test="${not empty currentNode.properties['description']}">
    <div class="dictionary-description">${currentNode.properties['description'].string}</div>
  </c:if>

  <c:choose>
    <c:when test="${renderContext.editMode}">
      <c:if test="${not empty currentNode.properties['imageUrl']}">
        <div class="dictionary-image-url"><a href="${currentNode.properties['imageUrl'].string}" >${currentNode.properties['imageUrl'].string}</a> </div>
      </c:if>

      <c:if test="${not empty currentNode.properties['videoUrl']}">
        <div class="dictionary-video-url"><a href="${currentNode.properties['videoUrl'].string}">${currentNode.properties['videoUrl'].string}</a></div>
      </c:if>
    </c:when>
    <c:otherwise>

      <c:if test="${not empty currentNode.properties['imageUrl']}">
        <div class="dictionary-image-url">
          <img src="${currentNode.properties['imageUrl'].string}"  alt=" " />
        </div>
      </c:if>

      <c:if test="${not empty currentNode.properties['videoUrl']}">
        <div class="dictionary-video-url">
          <iframe width="854" height="480" src="${currentNode.properties['videoUrl'].string}" frameborder="0" allowfullscreen></iframe>
        </div>
      </c:if>
    </c:otherwise>
  </c:choose>

</div>