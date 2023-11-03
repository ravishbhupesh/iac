package com.infy.templates.aws.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Response {

    private String code_amount;
    private String code_interval;
    private String code_length;
    private String code_rate;
    private String code_type;
    private String code_value;
    private String code_xref;
    private String description;
    private String time_stamp;
    private String code_flag;
    private String date_stamp;
    private String delete_flag;
    private String short_desc;
    private String user_id;
    private String shipcomp_code;
}
