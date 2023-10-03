package com.infy.templates.aws.app.services;

import com.amazonaws.services.lambda.runtime.LambdaLogger;
import com.infy.templates.aws.app.dto.Request;
import com.infy.templates.aws.app.dto.Response;

public interface AppService {

	Response processRequest(Request request, LambdaLogger logger);
}
