package com.example.rest.controller;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class MainController {
	
	Logger log = LoggerFactory.getLogger(this.getClass());

	@RequestMapping(value="/login")
	public JSONObject testConn(@RequestBody JSONObject obj) {
		
		log.info("■받은값...:"+ obj);
		
		String uri = "http://localhost:8050/login"; 
		JSONObject result = null ; 
		
	    HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
	    factory.setConnectTimeout(3*1000);
	    factory.setReadTimeout(3*1000);
		
	    RestTemplate restTemplate = new RestTemplate(factory);

	    HttpHeaders headers = new HttpHeaders(); 
	    headers.setContentType(MediaType.APPLICATION_JSON);
	    HttpEntity<JSONObject> entity = new HttpEntity<JSONObject>(obj,headers);
	    result = restTemplate.postForObject(uri, entity, JSONObject.class);
		
	    log.info("■통신결과...:"+ result.toString() );
		
		JSONObject res = new JSONObject();
		res.put("result", "ok");
		res.put("token", result.get("result"));
		
	    log.info("■보내는값...:"+ res.toString() );
		
		return res;
	}
	
	@RequestMapping(value="/getData")
	public JSONObject getData(@RequestBody JSONObject obj, HttpServletRequest req) {
		
		log.info("■받은값...:"+ obj);

		Cookie[] cookies = req.getCookies();

		String token = "" ; 
		if(cookies != null){

			for(int i=0; i<cookies.length; i++){

				Cookie cookie = cookies[i];
				String cname = cookie.getName(); // 쿠키 이름 가져오기
				String cvalue = cookie.getValue(); // 쿠키 값 가져오기
				
				if (cname.equals("token")) { 
					token = cvalue ; 
				}

			}

		}
		
		String uri = "http://localhost:8050/hello"; 
		JSONObject result = null ; 
		
	    HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
	    factory.setConnectTimeout(3*1000);
	    factory.setReadTimeout(3*1000);
		
	    RestTemplate restTemplate = new RestTemplate(factory);

	    HttpHeaders headers = new HttpHeaders(); 
	    headers.setContentType(MediaType.APPLICATION_JSON);
//	    headers.add("Authorization", "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJkYXRhIjp7ImlkIjoibW9ubyIsInB3ZCI6IjEyMzAwNCJ9LCJleHAiOjE1ODMwNjAzNjgyMDJ9.1UejFS9k8EHlZLXJKjmPzxQbiiT-UCmMtWFhMIr02Ao");
	    headers.add("Authorization", token);
	    HttpEntity<JSONObject> entity = new HttpEntity<JSONObject>(obj,headers);
   
	    result = restTemplate.postForObject(uri, entity, JSONObject.class);
		
	    log.info("■통신결과...:"+ result.toString() );
		
		JSONObject res = new JSONObject();
		res.put("result", "ok") ;
		res.put("val", result.get("val"));
		return res;
	}

}
