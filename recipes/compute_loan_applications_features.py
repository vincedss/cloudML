# -*- coding: utf-8 -*-
import dataiku
import pandas as pd, numpy as np
from dataiku import pandasutils as pdu

# Recipe inputs

loans_application_history_enriched = dataiku.Dataset("loan_history_enriched")
df = loans_application_history_enriched.get_dataframe()

df['debt_amnt'] = [d*df.installment.values[idx]/100.0 for idx,d in enumerate(df.dti.values)]

df["debt_amnt_norm"] = (df.debt_amnt.values - np.mean(df.debt_amnt.values))/np.std(df.debt_amnt.values)
df["instal_norm"] = (df.installment.values - np.mean(df.installment.values))/np.std(df.installment.values)


# Recipe outputs
loan_applications_features = dataiku.Dataset("loan_history_features")
loan_applications_features.write_with_schema(df)