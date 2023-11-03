package com.infy.templates.aws.app.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Request {

    private String code_type;
    private String code_value;
    private String shipcomp_code;
}
