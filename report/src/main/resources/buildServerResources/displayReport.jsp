<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="/include.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- com.goldin.plugins.teamcity.report.ReportExtension#fillModel() --%>
<jsp:useBean id="report" scope="request" type="java.util.List"/>
<jsp:useBean id="action" scope="request" type="java.lang.String"/>

<c:url var="ajaxAction" value="${ action }"/>

<style type="text/css">
    table#reportTable    { border       : 1px dotted }
    table#reportTable td,
    table#reportTable th { border-bottom: 1px dotted;
                           border-right : 1px dotted }
</style>

<script type="text/javascript">
    ( function( j ){
        j( function()
        {
            j( '#evaluateLink' ).click( function(){
                j.post( "${ ajaxAction }", // Goes to ReportController
                        { code: j( '#evalCode' ).val()},
                        function( response ) {
                            j( '#evalResult' ).val( response );
                            j( '#evalCode'   ).focus();
                        },
                        'text' );
            })
        });
    })( jQuery );
</script>



<form action="#" id="codeForm">

<textarea name="evalCode" id="evalCode" cols="80" rows="15">
# Type your script and click "Evaluate", lines starting with '#' are ignored.

# Variables available in the script context:
# * "request" - instance of javax.servlet.http.HttpServletRequest
# * "context" - instance of org.springframework.context.ApplicationContext
# * "server"  - instance of jetbrains.buildServer.serverSide.SBuildServer

# To retrieve currently logged in user:
# Class.forName( 'jetbrains.buildServer.web.util.SessionUser' ).getUser( request )

# To retrieve SBuildServer instance:
# context.getBean( Class.forName( 'jetbrains.buildServer.serverSide.SBuildServer' ))
</textarea>
<a href="#" id="evaluateLink">Evaluate</a>
<textarea name="evalResult" id="evalResult" cols="80" rows="15"></textarea>

</form>

<table id="reportTable">
    <c:forEach items="${report}" var="table">

        <%-- Every "table" is a 4-elements list: table title, left column header, right column header, data table --%>
        <c:set var="title"       value="${ table[ 0 ] }"/>
        <c:set var="leftHeader"  value="${ table[ 1 ] }"/>
        <c:set var="rightHeader" value="${ table[ 2 ] }"/>
        <c:set var="dataTable"   value="${ table[ 3 ] }"/>

        <tr>
            <td colspan="2" style="text-align: center; vertical-align: middle;"><h2>${ title }</h2></td>
        </tr>
        <tr>
            <th>${ leftHeader  }</th>
            <th>${ rightHeader }</th>
        </tr>
        <c:forEach items="${ dataTable.keySet() }" var="key">
        <tr>
            <td><code>${ key }</code></td>
            <td><code>${ dataTable.get( key ) }</code></td>
        </tr>
        </c:forEach>
    </c:forEach>
</table>
