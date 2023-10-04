package com.infy.templates.aws.app.jedis;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Collections;
import java.util.Set;

import org.apache.commons.pool2.impl.GenericObjectPoolConfig;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.databind.ObjectMapper;

import redis.clients.jedis.DefaultJedisClientConfig;
import redis.clients.jedis.HostAndPort;
import redis.clients.jedis.JedisClientConfig;
import redis.clients.jedis.JedisCluster;
import redis.clients.jedis.JedisPoolConfig;
import software.amazon.awssdk.http.urlconnection.UrlConnectionHttpClient;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.secretsmanager.SecretsManagerClient;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueRequest;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueResponse;

public final class JedisClient {

	private static final String AWS_REGION = System.getenv("AWS_REGION");
	private static final String ACCESS_SECRET = System.getenv("ACCESS_SECRET");
	private static final SecretsManagerClient SECRETS_MANAGER_CLIENT = SecretsManagerClient.builder()
			.region(Region.of(AWS_REGION)).httpClient(UrlConnectionHttpClient.builder().build()).build();

	private static JedisCluster jedisCluster = null;

	private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

	static {
		OBJECT_MAPPER.setSerializationInclusion(Include.NON_NULL);
		//JedisCredentials jedisCredentials = fetchCredentialsFromSecretManager();
		//initialize(jedisCredentials);
		initialize(null);
	}

	private static void initialize(JedisCredentials jedisCredentials) {
		HostAndPort hostAndPort = new HostAndPort(System.getenv("REDIS_CLUSTER_URL"), 6379);
		jedisCluster = new JedisCluster(Set.of(hostAndPort));

	}

	private static JedisCredentials fetchCredentialsFromSecretManager() {
		JSONObject input = null;
		try {
			input = (JSONObject) new JSONParser().parse(getSecretValue());
			return new JedisCredentials((String) input.get("username"), (String) input.get("password"));
		} catch (ParseException e) {
			return null;
		}
	}

	private static String getSecretValue() {
		GetSecretValueRequest request = GetSecretValueRequest.builder().secretId(ACCESS_SECRET).build();
		GetSecretValueResponse response = SECRETS_MANAGER_CLIENT.getSecretValue(request);
		return response.secretString();
	}

	public <T> T fetch(String key, Class<T> typeClass) {
		if (null != key) {
			String jsonStr = jedisCluster.get(key);
			
			try {
				return OBJECT_MAPPER.readValue(jsonStr.getBytes(StandardCharsets.UTF_8), typeClass);
			} catch (IOException e) {
				return null;
			}
		}
		return null;
	}

}
