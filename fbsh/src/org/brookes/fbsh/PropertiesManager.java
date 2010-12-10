package org.brookes.fbsh;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Properties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class PropertiesManager {
	
	private static final Log LOG = LogFactory.getLog(PropertiesManager.class);
	
	public static String getProperty(String key) {
		Properties props = new Properties();
		String value = null;
		
		try {
			URI uri = ClassLoader.getSystemResource("conf/fbsh.properties").toURI();
			FileInputStream fis = new FileInputStream(new File(uri));
			props.load(fis);
			fis.close();
			value = props.getProperty(key);
		} catch (FileNotFoundException e) {
			LOG.error(key, e);
		} catch (IOException e) {
			LOG.error(key, e);
		} catch (URISyntaxException e) {
			LOG.error(key, e);
		}
		
		return value;
	}
	
	public static void setProperty(String key, String value) {
		Properties props = new Properties();
		
		try {
			URI uri = ClassLoader.getSystemResource("conf/fbsh.properties").toURI();
			FileInputStream fis = new FileInputStream(new File(uri));
			props.load(fis);
			fis.close();
			if(props.containsKey(key))
				props.setProperty(key, value);
			else
				props.put(key, value);
			FileOutputStream fos = new FileOutputStream(new File(uri));
			props.store(fos, null);
			fos.close();
		} catch (FileNotFoundException e) {
			LOG.error(key, e);
		} catch (IOException e) {
			LOG.error(key, e);
		} catch (URISyntaxException e) {
			LOG.error(key, e);
		}
	}
}
