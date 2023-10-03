package com.infy.templates.aws.app;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.nio.charset.Charset;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import com.amazonaws.services.lambda.runtime.logging.LogLevel;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.infy.templates.aws.app.dto.Request;
import com.infy.templates.aws.app.dto.Response;
import com.infy.templates.aws.app.services.AppService;
import com.infy.templates.aws.app.services.impl.AppServiceImpl;

public class AppHandler implements RequestStreamHandler {
	
	private final AppService service = new AppServiceImpl();
	
	private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
	
	static {
		OBJECT_MAPPER.setSerializationInclusion(Include.NON_NULL);
	}

	@Override
	public void handleRequest(InputStream in, OutputStream out, Context context) throws IOException {
		LambdaLogger logger = context.getLogger();
		logger.log("AppHandler::handleRequest START", LogLevel.INFO);
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObject = null;
		try {
			BufferedReader reader = new BufferedReader(new InputStreamReader(in, Charset.forName("US-ASCII")));
			jsonObject = (JSONObject) jsonParser.parse(reader);
			Request request = OBJECT_MAPPER.readValue(jsonObject.get("body").toString(), Request.class);
			
			Response response = service.processRequest(request, logger);
			
			out.write(prepareResponse(OBJECT_MAPPER.writeValueAsString(response)));
			
		} catch (ParseException e) {
			e.printStackTrace();
		} finally {
			logger.log("AppHandler::handleRequest END", LogLevel.INFO);
		}
	}

	private byte[] prepareResponse(String responseStr) {
		JSONObject responseJson = new JSONObject();
		responseJson.put("statusCode", 200);
		responseJson.put("body", responseStr);
		responseJson.put("isBase64Encoded", false);
		return responseJson.toJSONString().getBytes();
	}

}
