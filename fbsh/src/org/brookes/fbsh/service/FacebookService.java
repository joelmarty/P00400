package org.brookes.fbsh.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.brookes.fbsh.PropertiesManager;

import com.restfb.Connection;
import com.restfb.DefaultFacebookClient;
import com.restfb.FacebookException;
import com.restfb.FacebookJsonMappingException;
import com.restfb.Parameter;
import com.restfb.types.FacebookType;
import com.restfb.types.Post;

public class FacebookService {

	private static final Log LOG = LogFactory.getLog(FacebookService.class);
	
	public static List<Post> getFeed(boolean update) throws FacebookException {
		
		DefaultFacebookClient facebookClient = new DefaultFacebookClient(PropertiesManager.getProperty("access_token"));

		Connection<Post> myFeed = null;
		if (update) {
			 myFeed = facebookClient.fetchConnection("me/home", Post.class, Parameter.with("since", PropertiesManager.getProperty("last_update")));
		} else {
			myFeed = facebookClient.fetchConnection("me/home", Post.class, Parameter.with("limit", 30));
		}
		PropertiesManager.setProperty("last_update", new SimpleDateFormat().format(new Date(System.currentTimeMillis())));
		
		LOG.debug("Fetch " + myFeed.getData().size() + " posts");
		
		return myFeed.getData();
	}
	
	public static String likePost(Post p) throws FacebookException {
		DefaultFacebookClient facebookClient = new DefaultFacebookClient(PropertiesManager.getProperty("access_token"));
		
		String response = facebookClient.publish(p.getId() + "/likes", String.class);
		if(!response.equals("true")) {
			LOG.error("post was not liked:" + response);
		} else {
			LOG.debug("post was liked with response:" + response);
		}
		return response;
	}
	
	public static void publishPost(String content) throws FacebookJsonMappingException, FacebookException {
		DefaultFacebookClient facebookClient = new DefaultFacebookClient(PropertiesManager.getProperty("access_token"));
		FacebookType response = facebookClient.publish("me/feed", FacebookType.class, Parameter.with("message", content));
		
		LOG.debug("published message with id: " + response.getId());
	}
}
