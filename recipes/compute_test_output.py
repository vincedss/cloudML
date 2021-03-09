# -*- coding: utf-8 -*-
import dataiku
import pandas as pd, numpy as np
from dataiku import pandasutils as pdu

# Read recipe inputs
loan_history_enriched = dataiku.Dataset("loan_history_enriched")
loan_history_enriched_df = loan_history_enriched.get_dataframe()


# Compute recipe outputs from inputs
# TODO: Replace this part by your actual code that computes the output, as a Pandas dataframe
# NB: DSS also supports other kinds of APIs for reading and writing data. Please see doc.

test_output_df = loan_history_enriched_df # For this sample code, simply copy input to output


# Write recipe outputs
test_output = dataiku.Dataset("test_output")
test_output.write_with_schema(test_output_df)
