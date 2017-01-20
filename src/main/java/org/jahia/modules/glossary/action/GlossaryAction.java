package org.jahia.modules.glossary.action;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.jcr.NodeIterator;
import javax.jcr.RepositoryException;
import javax.jcr.query.Query;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.jahia.bin.Action;
import org.jahia.bin.ActionResult;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.JCRSessionWrapper;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.URLResolver;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *  Glossary Action.
 */
public class GlossaryAction extends Action {

    private static Logger logger = LoggerFactory.getLogger(GlossaryAction.class);
    private static Map<String, Object> glossaryCacheMap = null;
    private SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
    
    @Override
    public ActionResult doExecute(HttpServletRequest req, RenderContext renderContext, Resource resource, JCRSessionWrapper session, Map<String, List<String>> parameters, URLResolver urlResolver) throws Exception {
        logger.info("doExecute: begins the GlossaryAction operation.");

        try {
            /*checking the necessary parameters*/
            if (StringUtils.isEmpty(req.getParameter("path"))) 
                throw new Exception("The parameter path is missing and is required.");
            
            if (StringUtils.isEmpty(req.getParameter("keyword"))) 
                throw new Exception("The parameter keyword is missing and is required.");
            
            /* getting the parameters */
            String path = req.getParameter("path");
            String keyword = req.getParameter("keyword").toLowerCase();

            /* returns the specific information if the keyword exists parameter */
            return new ActionResult(HttpServletResponse.SC_OK, "", getKeywordFromCache(session, keyword, path));

        }  catch (Exception ex) {
            logger.error("doExecute(), Error,", ex);
            return new ActionResult(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    
    /**
     * getQueryResult
     * <p>The method returns the NodeIterator,
     * result of the query execution.</p>
     *
     * @param queryStr @String
     * @param session {@link JCRSessionWrapper}
     * @return {@link NodeIterator}
     * @throws RepositoryException
     */
    private NodeIterator getQueryResult(String queryStr, JCRSessionWrapper session) throws RepositoryException{
            // Getting the items  nodes.
            Query query = session.getWorkspace().getQueryManager().createQuery(queryStr, Query.JCR_SQL2);
            return  query.execute().getNodes();
    }
    
    
    /**
     * callQuery
     * <p>The method returns the properties of node into a map.</p> 
     *
     * @param session {@link JCRSessionWrapper}
     * @param strQuery @String
     * @return itemMap
     * @throws JSONException
     */
    private Map<String, String> callQuery(JCRSessionWrapper session, String strQuery) throws JSONException {
    	JCRNodeWrapper nodeItem = null;
    	Map<String, String> itemMap = new HashMap<>();
    			
        if(StringUtils.isNotEmpty(strQuery)) {
            try {
                NodeIterator iterator = getQueryResult(strQuery, session);
                while (iterator.hasNext()) {
                    nodeItem = (JCRNodeWrapper) iterator.next();
                    itemMap.put("keyword", nodeItem.getPropertyAsString("keyword").toLowerCase());
                    itemMap.put("description", nodeItem.getPropertyAsString("description"));
                    itemMap.put("imageUrl", nodeItem.getPropertyAsString("imageUrl"));
                    itemMap.put("videoUrl", nodeItem.getPropertyAsString("videoUrl"));
                    return itemMap;
                }
            } catch (RepositoryException rex) {
                logger.error("callQuery(), problem executing the jcr:query[" + strQuery + "]", rex);
            }
        }
        return null;
    }


    /**
     * getGlossaryItemByKeyword
     * <p>The method returns a map with a strQuery.</p>
     * 
     * @param session {@link JCRSessionWrapper}
     * @param keyword @String
     * @param searchPath @String
     * @return {@link Map}
     * @throws JSONException
     * @throws RepositoryException
     */
    private Map<String, String> getGlossaryItemByKeyword(JCRSessionWrapper session, String keyword, String searchPath) throws JSONException, RepositoryException {
        String strQuery = "SELECT * FROM [glsnt:dictionaryItem] AS item WHERE ISDESCENDANTNODE(item,['" + searchPath  + "'])  AND CONTAINS(item.keyword, '" + keyword + "') ";
        logger.error("query: " + strQuery);
        return callQuery(session, strQuery);
    }
    
    
    /**
     * getKeywordFromCache
     * <p>The method searches in cache and then in repository.</p>
     * 
     * @param session {@link JCRSessionWrapper}
     * @param keyword @String
     * @param searchPath @String
     * @return {@link JSONObject}
     * @throws JSONException
     */
    private JSONObject getKeywordFromCache(JCRSessionWrapper session, String keyword, String searchPath) {
    	String today = dateFormat.format(new Date());
    	JSONObject jObj = new JSONObject();
    	try {
	    	if( glossaryCacheMap == null || !glossaryCacheMap.containsKey("registerDate")){
	    		glossaryCacheMap = new HashMap<>();
	    		glossaryCacheMap.put("registerDate", today);
	    	}else{
	    		String registerDate = (String)glossaryCacheMap.get("registerDate");
	    		if(!registerDate.equals(today)){
	    			glossaryCacheMap = new HashMap<>();
	        		glossaryCacheMap.put("registerDate", today);
	    		}
	    	}
	    	 	
	    	if(!glossaryCacheMap.containsKey(keyword)){
	    		Map<String, String> itemMap = getGlossaryItemByKeyword(session, keyword, searchPath);
	    		if(itemMap != null)		
	    			glossaryCacheMap.put(keyword.toLowerCase(), itemMap);
	    	}

	    	if(glossaryCacheMap.containsKey(keyword)){
	    		logger.error("enter to set the word to map =>: " + keyword);
	    		jObj = new JSONObject();
	    		jObj.put("keyword", keyword);
	    		for (String key: ((HashMap<String, String>)glossaryCacheMap.get(keyword)).keySet()) 
	    			jObj.put(key, ((HashMap<String, String>)glossaryCacheMap.get(keyword)).get(key));
	 
	    	}
	    	
	    	logger.error("the map is : "  + glossaryCacheMap.toString());
    	} catch (Exception e) {
			logger.error("getKeywordCache(), error ", e);
		} 
    	
    	return jObj;
    }

}