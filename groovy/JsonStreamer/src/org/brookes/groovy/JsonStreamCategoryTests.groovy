package org.brookes.groovy;

import groovy.util.GroovyTestCase;

import java.util.Properties;

import org.json.JSONObject;

class JsonStreamCategoryTests extends GroovyTestCase {

	def void testPropToJson() {
		
		System.out.println("testing from properties to json");
		
		def inputProps = new Properties();
		
		//URI propuri = ClassLoader.getSystemResource("input.properties").toURI();
		FileInputStream fis = new FileInputStream(new File("input.properties"));
		
		inputProps.load(fis);
		fis.close();
		
		JSONObject json = new JSONObject();
		use (JsonStreamCategory) {
			inputProps >> json;
		}
		
		System.out.println("got json:\n" + json.toString(2));
	}
	
	def void testJsonToProp() {
		
		System.out.println("testing from json to properties");
		
		Properties props = new Properties()
		
		def jsonfile = "json.txt"
		
		def jsonstr = new File(jsonfile).text
		
		JSONObject json = new JSONObject(jsonstr);
		use (JsonStreamCategory) {
			props << json;
		}
		
		System.out.println("json is:\n" + json.toString(2));
		
		System.out.println("properties file contains:");
		props.keys().collect { key -> System.out.println("key: " + key.toString() + " has value " + props.get(key)); }
	}
}

