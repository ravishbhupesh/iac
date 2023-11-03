package com.infy.templates.aws.app.utils;

import com.infy.templates.aws.app.dto.Request;
import com.infy.templates.aws.app.dto.Response;
import lombok.extern.log4j.Log4j2;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

@Log4j2
public final class CodeDataSource {

    private static Map<Request, Response> codes = new HashMap<>();

    static {
        JSONParser parser = new JSONParser();

        try {
            JSONArray jsonCodes = (JSONArray) parser.parse(new InputStreamReader(
                    Objects.requireNonNull(Thread.currentThread().getContextClassLoader().getResourceAsStream("codes_data.json"))));

            for(Object c : jsonCodes) {
                JSONObject jsonObject =  (JSONObject) c;

                Request request = new Request((String) jsonObject.get("code_type"), (String) jsonObject.get("code_value"), (String) jsonObject.get("shipcomp_code"));

                Response response = new Response();
                response.setCode_amount((jsonObject.get("code_amount")).toString());
                response.setCode_interval((jsonObject.get("code_interval")).toString());
                response.setCode_length((jsonObject.get("code_length")).toString());
                response.setCode_rate((jsonObject.get("code_rate")).toString());
                response.setCode_type((String) jsonObject.get("code_type"));
                response.setCode_value((String) jsonObject.get("code_value"));
                response.setCode_xref((String) jsonObject.get("code_xref"));
                response.setDescription((String) jsonObject.get("description"));
                response.setTime_stamp(((Long) jsonObject.get("time_stamp")).toString());
                response.setCode_flag((String) jsonObject.get("code_flag"));
                response.setDate_stamp((String) jsonObject.get("date_stamp"));
                response.setDelete_flag((String) jsonObject.get("delete_flag"));
                response.setShort_desc((String) jsonObject.get("short_desc"));
                response.setUser_id((String) jsonObject.get("user_id"));
                response.setShipcomp_code((String) jsonObject.get("shipcomp_code"));

                codes.put(request, response);
            }

        } catch (FileNotFoundException e) {
            log.error("FileNotFoundException : {}", e.getMessage());
        } catch (IOException e) {
            log.error("IOException : {}", e.getMessage());
        } catch (ParseException e) {
            log.error("ParseException : {}", e.getMessage());
        }
    }

    private static final CodeDataSource INSTANCE = new CodeDataSource();

    public static CodeDataSource getInstance() {
        return INSTANCE;
    }

    public Response get(Request request) {

        return codes.get(request);
    }
}
