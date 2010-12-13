package org.brookes.groovy;

import java.util.Properties;
import org.json.*;

class JsonStreamCategory {
	
	// json to properties
	def static rightShift(Properties props, JSONObject json) {
		
		if(json.equals(null))
			json = new JSONObject()
		
		try {
			def keys = props.keys()
			keys.collect { key -> json.putOpt(key, props.get(key)) }
		} finally {
		
		}
	}
	
	//json to properties
	def static leftShift(Properties props, JSONObject json) {
		
		def input
		def output
		
		try {
			def keys = json.keys()
			keys.collect { key -> props.put(key, json.get(key)) }
		} finally {
		
		}
	}

}
