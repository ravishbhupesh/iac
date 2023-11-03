package com.infy.templates.aws.app.jedis;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.infy.templates.aws.app.dto.Response;
import lombok.extern.log4j.Log4j2;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import software.amazon.awssdk.http.urlconnection.UrlConnectionHttpClient;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.secretsmanager.SecretsManagerClient;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

@Log4j2
public final class JedisClient {

	private JedisClient() {
	}

	private static final JedisClient INSTANCE = new JedisClient();

	public static JedisClient getInstance() {
		return INSTANCE;
	}

	private static final String AWS_REGION = System.getenv("AWS_REGION");
	private static final String ACCESS_SECRET = System.getenv("ACCESS_SECRET");
	private static final SecretsManagerClient SECRETS_MANAGER_CLIENT = SecretsManagerClient.builder()
			.region(Region.of(AWS_REGION)).httpClient(UrlConnectionHttpClient.builder().build()).build();

	private static Jedis jedis = null;

	private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

	static {
		OBJECT_MAPPER.setSerializationInclusion(Include.NON_NULL);
		log.info("Connecting to Redis. Endpoint : {}", System.getenv("REDIS_HOST"));
		try (JedisPool jedisPool = new JedisPool(System.getenv("REDIS_HOST"), Integer.parseInt(System.getenv("REDIS_PORT")))) {
			jedis = jedisPool.getResource();
			log.info("Connection Successful!!!");
		} finally {
			if(null == jedis) {
				log.error("Unable to connect to redis!!!");
			}
		}
	}
	public <T> T fetch(String key, Class<T> typeClass) {
		if (null != key) {
			String jsonStr = jedis.get(key);
			log.info("Value for key : {}, in cache : {}", key, jsonStr);
			try {
				return (null != jsonStr) ? OBJECT_MAPPER.readValue(jsonStr.getBytes(StandardCharsets.UTF_8), typeClass) : null;
			} catch (IOException e) {
				log.error("IO Error : {}", e.getMessage());
				return null;
			}
		}
		return null;
	}

	public void add(String key, Response value) {

		String result = null;
		try {
			result = jedis.set(key, OBJECT_MAPPER.writeValueAsString(value));
		} catch (JsonProcessingException e) {
			log.error("JsonProcessingException : {}", e.getMessage());
		}
		log.info("key : {}, value : {}, added in cache. Result : {}", key, value, result);
	}

}
