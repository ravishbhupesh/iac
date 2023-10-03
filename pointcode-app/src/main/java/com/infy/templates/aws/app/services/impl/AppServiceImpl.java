package com.infy.templates.aws.app.services.impl;

import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.infy.templates.aws.app.dto.Request;
import com.infy.templates.aws.app.dto.Response;
import com.infy.templates.aws.app.jedis.JedisClient;
import com.infy.templates.aws.app.services.AppService;

public class AppServiceImpl implements AppService {
	
	private static final JedisClient JEDIS_CLIENT = new JedisClient();

	@Override
	public Response processRequest(Request request, LambdaLogger logger) {
		if(isRequestValid(request)) {
			String key = getKeyFromRequest(request);
			return JEDIS_CLIENT.fetch(key, Response.class);
		}
		return null;
	}

	private String getKeyFromRequest(Request request) {
		return null;
	}

	private boolean isRequestValid(Request request) {
		return true;
	}

}
