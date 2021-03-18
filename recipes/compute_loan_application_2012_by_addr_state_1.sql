SELECT 
    "addr_state" AS "addr_state",
    AVG(CAST("loan_amnt" AS REAL)) AS "loan_amnt_avg",
    SUM("loan_amnt") AS "loan_amnt_sum",
    MIN("int_rate") AS "int_rate_min",
    MAX("int_rate") AS "int_rate_max",
    AVG("int_rate") AS "int_rate_avg",
    AVG("installment") AS "installment_avg",
    MIN("dti") AS "dti_min",
    MAX("dti") AS "dti_max",
    AVG("dti") AS "dti_avg",
    AVG("annual_inc") AS "annual_inc_avg",
    AVG("emp_length_month") AS "emp_length_month_avg",
    COUNT(*) AS "count"
  FROM (
    SELECT 
        "loan_amnt" AS "loan_amnt",
        "funded_amnt" AS "funded_amnt",
        "funded_amnt_inv" AS "funded_amnt_inv",
        "term" AS "term",
        "int_rate" AS "int_rate",
        "installment" AS "installment",
        "grade" AS "grade",
        "sub_grade" AS "sub_grade",
        "issue_date" AS "issue_date",
        "zip_code" AS "zip_code",
        "addr_state" AS "addr_state",
        "dti" AS "dti",
        "annual_inc" AS "annual_inc",
        "emp_title" AS "emp_title",
        "emp_length_month" AS "emp_length_month",
        "home_ownership" AS "home_ownership",
        "verification_status" AS "verification_status",
        "loan_status" AS "loan_status",
        "pymnt_plan" AS "pymnt_plan",
        "desc" AS "desc",
        "purpose" AS "purpose",
        "title" AS "title"
      FROM "Design_MLCREDITSCORING_loan_applications_history_stacked"
    ) "dku__beforegrouping"
  GROUP BY "addr_state"