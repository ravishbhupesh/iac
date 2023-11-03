package com.infy.templates.aws.app.services.impl;

import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.infy.templates.aws.app.dto.Request;
import com.infy.templates.aws.app.dto.Response;
import com.infy.templates.aws.app.jedis.JedisClient;
import com.infy.templates.aws.app.services.AppService;
import com.infy.templates.aws.app.utils.CodeDataSource;

public class AppServiceImpl implements AppService {
	
	private static final JedisClient JEDIS_CLIENT =  JedisClient.getInstance();

	private static final CodeDataSource CODE_DATA_SOURCE = CodeDataSource.getInstance();

	@Override
	public Response processRequest(Request request, LambdaLogger logger) {
		if(isRequestValid(request)) {
			String key = getKeyFromRequest(request);
			logger.log("Key created from request : {}" + key);
			Response response = JEDIS_CLIENT.fetch(key, Response.class);
			if(null == response) {
				Response resp = CODE_DATA_SOURCE.get(request);
				logger.log("Adding Key : " + key + " with value : " + resp + " to the cache!!!");
				JEDIS_CLIENT.add(key, resp);
				return resp;
			} else {
				return response;
			}
		}
		return null;
	}

	private String getKeyFromRequest(Request request) {
		return request.getCode_type() + "_" + request.getCode_value() + "_" + request.getShipcomp_code();
	}

	private boolean isRequestValid(Request request) {
		return true;
	}

}
