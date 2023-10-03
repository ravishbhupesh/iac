package com.infy.templates.aws.app.jedis;

public class JedisCredentials {

	private String username;
	private String password;
	
	public JedisCredentials(String username, String password) {
		this.username = username;
		this.password = password;
	}

	public String getUsername() {
		return username;
	}

	public String getPassword() {
		return password;
	}

}