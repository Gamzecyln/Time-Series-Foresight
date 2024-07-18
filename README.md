# Seasonal Trend Analysis of Domestic Tourism Revenue Indices: A Time Series Study from 2009 to 2023
# Project Overview
This project focuses on the analysis of seasonal trends in domestic tourism revenue indices in Turkey from 2009 to 2023. The data set includes revenue indices specific to the domestic tourism sector, considering seasonal adjustments to provide accurate insights into the trends and patterns over the specified period.

Domestic tourism in Turkey is a vital sector, capturing the profiles, travel characteristics, and expenditure estimates of residents and foreign visitors traveling within the country. This research is jointly conducted by the Ministry of Culture and Tourism and the Turkish Statistical Institute (TÜİK). According to TÜİK's Household Domestic Tourism Survey, in 2021, approximately 8.95 million residents traveled domestically, marking a significant increase compared to the previous year. The total number of trips taken with at least one overnight stay was 10.71 million, a 48.9% increase from the same quarter of the previous year, with a total of 80.38 million overnight stays, averaging 7.5 nights per trip.

Annually, the total number of trips increased by 23.2% to 52.77 million in 2021. However, the total number of overnight stays decreased by 2.2% to 458.87 million, with an average of 8.7 nights per trip.

# Data Set Information
The dataset comprises revenue indices from the domestic tourism sector, meticulously selected to account for seasonality. It spans from 2009 to 2023, providing a comprehensive view of the sector's performance over this period. The seasonal adjustment in the data allows for a more precise analysis of underlying trends and patterns, eliminating the distortions caused by seasonal fluctuations.



# Objectives

Identify Long-term Trends: Detect persistent trends in domestic tourism revenue over the study period.

Seasonality Assessment: Quantify the impact of seasonal variations on tourism revenues.

Predictive Modeling: Develop robust models to forecast future revenue trends.

Insight Generation: Provide actionable insights for strategic decision-making in the tourism sector.

# Analytical Approach
## Data Preprocessing 

Seasonal Adjustment: Applied to remove seasonal effects and highlight true data trends.

Differencing: Performed differencing to stabilize the mean of the time series and achieve stationarity.

### Model Development and Evaluation

Autocorrelation Function (ACF) Analysis: Conducted to identify significant lags indicating seasonality and non-stationarity.

Partial Autocorrelation Function (PACF) Analysis: Used to determine appropriate orders for ARIMA models.

Box-Jenkins Methodology: Employed ARIMA models tailored to the seasonally adjusted series.

Exponential Smoothing: Implemented Seasonal Exponential Smoothing to enhance forecast accuracy.

#### Diagnostic Checks

Residual ACF Analysis: Checked for white noise to validate model assumptions.

Box-Ljung Test: Ensured no residual autocorrelation, confirming model adequacy.

Durbin-Watson Test: Detected potential autocorrelation issues, ensuring model reliability.

# Key Findings
## Seasonal Decomposition

Initial ACF analysis revealed significant autocorrelations at various lags, confirming the presence of strong seasonal patterns.
Seasonal differencing successfully removed these effects, rendering the series stationary for further analysis.

# Model Performance

Additive and Multiplicative Decomposition: Neither approach produced residuals consistent with white noise, indicating inadequacy for this dataset.

## Regression Analysis:

Additive Regression: Statistically insignificant with a p-value > 0.05.

Multiplicative Regression: Significant for some variables, but residuals indicated model inadequacy.

### ARIMA Models:

ARIMA(1,1,0)_12 emerged as the most effective model, with significant p-values and strong fit metrics (RMSE and BIC).

#### Exponential Smoothing:
Seasonal Exponential Smoothing proved effective, with residual diagnostics confirming white noise and model suitability.

# Conclusion

This comprehensive analysis identified and modeled the seasonal dynamics of domestic tourism revenue indices. The ARIMA(1,1,0)_12 model demonstrated superior forecasting capability, validated through rigorous statistical testing. These insights will empower stakeholders to make informed, strategic decisions in the domestic tourism sector.


