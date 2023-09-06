# Scope-of-salaries-in-IT-jobs-from-2020-to-2022
Analyzing the trend(demand) and the salaries for IT roles in data science that were paid before, during, and post-COVID.


### Brief Description:
This project is for my self-practice which is made by keeping the public in mind who want to know how covid 19 affected the trend of IT roles. This narrates the findings on the salaries for various IT roles, mostly related to the data science field during the three COVID stages in 2020, 2021, and 2022. I wanted to tell the audience about the average salary paid to the employee, which is based on job role, location of the company(country name), and year. A map is visualized with the geo-location point of the country, which describes the country name, average covid 19 cases in that year, and average salary. In addition to this map is a bar chart plotted, which visualizes the average wage of different job roles paid in a particular country. Both the map and bar chart are entirely interactive, and the project is implemented using Shiny.


### Introduction and motivation:
After building an interest in the data science field, I used to research more on the salaries paid to the related areas. Though I want to be an entrepreneur in this stream, I am always curious to know how the job role with the experience works and the amount of pay scale offered. According to some reports, data science and software jobs got triggered during the COVID-19 lockdown, just like the other jobs, and the wages were paid less and some even lost jobs. But the exciting part is that after the 2nd quarter of 2021, the count of data science job vacancies went huge. Therefore, I want to analyze the trend(demand) and the salaries for IT roles in data science that were paid before COVID-19, during covid, and post-covid.

### Possible Questions raised:
1. For each experience level, in which trend have the salaries of IT roles gone from 2020 to 2022, and what fresher job got paid better each year?
2. Did COVID-19 shift more office jobs to remote jobs, and which country offered more remote or office jobs during and after COVID-19?
3. Did COVID-19 make the companies pay less to the employees, and which jobs became more each year?

### Data Sources:
A. AI/ML and Big data salaries, reported by the public through the ai-jobs.net survey form.
B. Covid-19 Open data, provided by Google Covid-19 Open Data Repository.
Data source A helps me to answer question 1. And the combination of Data sources A and B helps me to answer questions 2 and 3.

### Description of data sources:
• Tabular data: 774 rows x 10 columns(New record(s) gets added based on daily survey count). This contains some numerical and categorical features (https://salaries.ai-jobs.net/download/).
• Tabular data(New records get added daily). The data is read and stored through the Google API(If we want to retrieve the data of USA - https://storage.googleapis.com/covid19-open-data/v3/location/ US.csv). The ISO code must be changed before .csv in the link concerning the country where we want to extract the data.

### References:
[1] Javier Canales, Luna (2022), Article shows ‘Data science salary expectations in 2022, 18.05.2022. URL: https://www.datacamp.com/blog/data-science-salaries. 


