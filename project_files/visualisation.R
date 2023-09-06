library(ggplot2)
library(dplyr)
data_frame<-read.csv('cleaned_data.csv')
#get the experience level unique values
unique(data_frame['experience_level'])
#EN- Entry level
#MI- Mid level
#SE- Senior level
#EX- Executive level
##########
#getting the unique IT roles
sort(unique(data_frame$job_title) )
#question 1: For each experience level, in which trend have the salaries of IT roles
#gone fro 2020 to 2022, and what fresher job got paid better each year?
#----------------------------
#1.a
#getting the mean value of salaries for each role and experience
pdf(file = 'experience_salary_trends.pdf')
par( mfrow= c(2,2) )
mean_values<-c()
for (job in sort(unique(data_frame$job_title))){
  ex_val<-c()
  for (exp_lvl in sort(unique(data_frame$experience_level))){
    yr_val<-c()
    for (yr in c(2020,2021,2022)){
      salary_mean<-mean(filter(data_frame,job_title==job,
                  experience_level==exp_lvl,work_year==yr)$salary_in_usd)
      #print(paste('Job: ',job))
      #print(paste('Year: ',yr))
      #print(paste('Exp level: ',exp_lvl))
      #print(paste('Mean salary: ',salary_mean))
      yr_val<-c(yr_val,salary_mean)
    }
    if (FALSE %in% (is.na(yr_val))){
      if (exp_lvl=='EN'){
        exp_lvl='Entry Level'
      }
      if (exp_lvl=='EX'){
        exp_lvl='Executive Level'
      }
      if (exp_lvl=='MI'){
        exp_lvl='Mid Level'
      }
      if (exp_lvl=='SE'){
        exp_lvl='Senior Level'
      }
      barplot(yr_val~c(2020,2021,2022),main=paste(job,', ',exp_lvl),
              xlab = 'Year',ylab='Salary')
    }
    else{
      plot(0,0)
    }
    
    ex_val<-c(ex_val,yr_val)
  }
  mean_values<-c(mean_values,ex_val)
}

#for displaying the multiple plots in one page - 
#https://www.geeksforgeeks.org/how-to-export-multiple-plots-to-pdf-in-r/


dev.off()


#and what fresher job got paid better each year?
#get the jobs with fresher jobs and 


yr_2020<-c()
yr_2021<-c()
yr_2022<-c()

for (job in unique(data_frame$job_title)){
  for (year in c(2020,2021,2022)){
    mean<-mean(filter(data_frame,job_title==job,
                      work_year==year,experience_level=='EN')$salary_in_usd)
    if (is.na(mean)){
      mean=0
    }
    if (year==2020){yr_2020<-c(yr_2020,mean)}
    if (year==2021){yr_2021<-c(yr_2021,mean)}
    if (year==2022){yr_2022<-c(yr_2022,mean)}
  }
}

unique_jobs<-unique(data_frame$job_title)
frsh_2020_ind<-which(yr_2020==max(yr_2020))
frsh_2021_ind<-which(yr_2021==max(yr_2021))
frsh_2022_ind<-which(yr_2022==max(yr_2022))

print(paste('During 2020: ',unique_jobs[frsh_2020_ind]))
print(paste('During 2021: ',unique_jobs[frsh_2021_ind]))
print(paste('During 2022: ',unique_jobs[frsh_2022_ind]))

#plotting the values for each year


#for rotating the axis ticks - https://stackoverflow.com/questions/1330989/rotating-and-spacing-axis-labels-in-ggplot2
#for adding the title - https://environmentalcomputing.net/graphics/ggplot/ggplot-labels/
#getting the visualization for 2020
data_2020<-data.frame('Role'=unique_jobs,'Average_salary'=yr_2020)
ggplot(data_2020, aes(x=Role, y=Average_salary)) + geom_bar(stat = "identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  ggtitle('Average salaries of fresher jobs in 2020')

#getting the visualization for 2021
data_2021<-data.frame('Role'=unique_jobs,'Average_salary'=yr_2021)
ggplot(data_2021, aes(x=Role, y=Average_salary)) + geom_bar(stat = "identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  ggtitle('Average salaries of fresher jobs in 2021')

#getting the visualization for 2022
data_2022<-data.frame('Role'=unique_jobs,'Average_salary'=yr_2022)
ggplot(data_2022, aes(x=Role, y=Average_salary)) + geom_bar(stat = "identity")+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  ggtitle('Average salaries of fresher jobs in 2022')
#save the pictures and visualize

#question2
#Did Covid19 shift more office jobs to remote jobs, 
#and which country offered more remote or office jobs during and after covid19?

#creating the dataframe defining the remote jobs

remote_2020<-c()
remote_2021<-c()
remote_2022<-c()
for (year in c(2020,2021,2022)){
  for (ratio in c(0,50,100)){
    if (year==2020){
      data_count<-nrow(filter(data_frame,remote_ratio==ratio,work_year==2020))
      remote_2020<-c(remote_2020,data_count[1])
    }
    if (year==2021){
      data_count<-nrow(filter(data_frame,remote_ratio==ratio,work_year==2021))
      remote_2021<-c(remote_2021,data_count[1])
    }
    if (year==2022){
      data_count<-nrow(filter(data_frame,remote_ratio==ratio,work_year==2022))
      remote_2022<-c(remote_2022,data_count[1])
    }
  }
}


remote_data<-data.frame('Ratio'=c('Ratio_0','Ratio_50','Ratio_100'),'count_2020'=remote_2020,
                             'count_2021'=remote_2021,
                             'count_2022'=remote_2022)
#remote ratio 2020
ggplot(remote_data,aes(x=Ratio,y=count_2020))+geom_point()+
  ggtitle('Remote ratio of jobs during 2020')
#remote ratio 2021
ggplot(remote_data,aes(x=Ratio,y=count_2021))+geom_point()+
  ggtitle('Remote ratio of jobs during 2021')
#remote ratio 2022
ggplot(remote_data,aes(x=Ratio,y=count_2022))+geom_point()+
  ggtitle('Remote ratio of jobs during 2022')

#saving the dataframe
write.csv(remote_data,'remote_data.csv')

#getting the percentages of remote ratio in every year.
percentage_2020<-c()
for (ind in c(1,2,3)){
  ratio<-remote_data$count_2020[ind]
  percentage<-ratio/sum(remote_data$count_2020)*100
  percentage_2020<-c(percentage_2020,percentage)
  print(percentage)
}


#percentage_2021
percentage_2021<-c()
for (ind in c(1,2,3)){
  ratio<-remote_data$count_2021[ind]
  percentage<-ratio/sum(remote_data$count_2021)*100
  percentage_2021<-c(percentage_2021,percentage)
  print(percentage*100)
}

#percentage_2022
percentage_2022<-c()
for (ind in c(1,2,3)){
  ratio<-remote_data$count_2022[ind]
  percentage<-ratio/sum(remote_data$count_2022)*100
  percentage_2022<-c(percentage_2022,percentage)
  print(percentage*100)
}


remote_data_percentage<-data.frame('Ratio'=c('Ratio_0_percentage','Ratio_50_percentage',
                                  'Ratio_100_percentage'),'count_2020'=remote_2020,
                        'count_2021'=remote_2021,
                        'count_2022'=remote_2022)
#remote ratio 2020
ggplot(remote_data_percentage,aes(x=Ratio,y=percentage_2020,group=1))+
  geom_point()+geom_line()+
  ggtitle('Remote ratio percentage of jobs during 2020')+
  geom_text(aes(label=round(percentage_2020,2)), vjust=-0.6, color="black",
              position = position_dodge(0.9), size=5)
#remote ratio 2021
ggplot(remote_data_percentage,aes(x=Ratio,y=percentage_2021,group=1))+
  geom_point()+geom_line()+
  ggtitle('Remote ratio percentage of jobs during 2021')+
  geom_text(aes(label=round(percentage_2021,2)), vjust=-0.6, color="black",
            position = position_dodge(0.9), size=5)
#remote ratio 2022
ggplot(remote_data_percentage,aes(x=Ratio,y=percentage_2022,group=1))+
  geom_line()+geom_point()+
  ggtitle('Remote ratio percentage of jobs during 2022')+
  geom_text(aes(label=round(percentage_2022,2)), vjust=-0.6, color="black",
            position = position_dodge(0.9), size=5)
  

#2.2

country_total_count<-c()
job_count_2020<-c()
job_count_2021<-c()
job_count_2022<-c()
covid_mean_2020<-c()
covid_mean_2021<-c()
covid_mean_2022<-c()
for (country in unique(data_frame$company_location)){
  total_count<-nrow(filter(data_frame,company_location==country))
  country_total_count<-c(country_total_count,total_count)
  for (yr in c(2020,2021,2022)){
    yr_count<-nrow(filter(data_frame,company_location==country,
                            work_year==yr))
    covid_mean<-mean(filter(data_frame,company_location==country,
                            work_year==yr)$covid_mean_cases)
    if (is.na(covid_mean)){
      covid_mean=0
    }
    if (yr == 2020){job_count_2020<-c(job_count_2020,yr_count)
    covid_mean_2020<-c(covid_mean_2020,covid_mean)}
    if (yr == 2021){job_count_2021<-c(job_count_2021,yr_count)
    covid_mean_2021<-c(covid_mean_2021,covid_mean)}
    if (yr == 2022){job_count_2022<-c(job_count_2022,yr_count)
    covid_mean_2022<-c(covid_mean_2022,covid_mean)}
  }
}

job_count_data<-data.frame('Country'=unique(data_frame$company_location),
                                            'Total Job count'=country_total_count,
                                            'Job count 2020'=job_count_2020,
                                            'Avg Cov19 cases 2020'=covid_mean_2020,
                                            'Job count 2021'=job_count_2021,
                                            'Avg Cov19 cases 2021'=covid_mean_2021,
                                            'Job count 2022'=job_count_2022,
                                            'Avg Cov19 cases 2022'=covid_mean_2022)



write.csv(job_count_data,'Job_count_data.csv')



#Did Covid19 make the companies pay less to the employees, 
#and which jobs became more each year?

#getting the countries according and their mean salaries

salary_2020<-c()
salary_2021<-c()
salary_2022<-c()
ac_covid_mean_2020<-c()
ac_covid_mean_2021<-c()
ac_covid_mean_2022<-c()
for (yr in c(2020,2021,2022)){
  for (country in unique(data_frame$company_location)){
    mean_salary<-mean(filter(data_frame,company_location==country,
                             work_year==yr)$salary_in_usd)
    covid_mean<-mean(filter(data_frame,company_location==country,
                            work_year==yr)$covid_mean_cases)
    if (is.na(covid_mean)){
      covid_mean=0
    }
    if(is.na(mean_salary)){
      mean_salary=0
    }
    if (yr==2020){
      salary_2020<-c(salary_2020,mean_salary)
      ac_covid_mean_2020<-c(ac_covid_mean_2020,covid_mean)
    }
    if (yr==2021){
      salary_2021<-c(salary_2021,mean_salary)
      ac_covid_mean_2021<-c(ac_covid_mean_2021,covid_mean)
    }
    if (yr==2022){
      salary_2022<-c(salary_2022,mean_salary)
      ac_covid_mean_2022<-c(ac_covid_mean_2022,covid_mean)
      
    }
  }
}


salary_data<-data.frame('Country'=unique(data_frame$company_location),
                        'Avg Salary 2020'=salary_2020,
                        '2020 Covid 19 Average cases'=ac_covid_mean_2020,
                        'Avg Salary 2021'=salary_2021,
                        '2021 Covid 19 Average cases'=ac_covid_mean_2021,
                        'Avg Salary 2022'=salary_2022,
                        '2022 Covid 19 Average cases'=ac_covid_mean_2022)

#wriiting the dataframe to csv

write.csv(salary_data,'Salary_data_each_year.csv')


common_countries<-c()
cc_2020_sal<-c()
cc_2021_sal<-c()
cc_2022_sal<-c()
cc_covid_mean_2020<-c()
cc_covid_mean_2021<-c()
cc_covid_mean_2022<-c()
for (country in unique(data_frame$company_location)){
  year_length=length(unique(filter(data_frame,company_location==country)$work_year))
  if (year_length==3){
    common_countries<-c(common_countries,country)
    for (yr in c(2020,2021,2022)){
      mean_salary<-mean(filter(data_frame,company_location==country,
                               work_year==yr)$salary_in_usd)
      covid_mean<-mean(filter(data_frame,company_location==country,
                              work_year==yr)$covid_mean_cases)
      if (is.na(mean_salary)){
        mean_salary=0
      }
      if (is.na(covid_mean)){
        covid_mean=0
      }
      if (yr==2020){
        cc_2020_sal<-c(cc_2020_sal,mean_salary)
        cc_covid_mean_2020<-c(cc_covid_mean_2020,covid_mean)
      }
      if (yr==2021){
        cc_2021_sal<-c(cc_2021_sal,mean_salary)
        cc_covid_mean_2021<-c(cc_covid_mean_2021,covid_mean)
      }
      if (yr==2022){
        cc_2022_sal<-c(cc_2022_sal,mean_salary)
        cc_covid_mean_2022<-c(cc_covid_mean_2022,covid_mean)
      }
    }
  }
}

common_countries_salaries<-data.frame(
  'Country Name'=common_countries,
  'Avg Salary 2020'=cc_2020_sal,
  'Avg covid cases 2020'=cc_covid_mean_2020,
  'Avg Salary 2021'=cc_2021_sal,
  'Avg covid cases 2021'=cc_covid_mean_2021,
  'Avg Salary 2022'=cc_2022_sal,
  'Avg covid cases 2022'=cc_covid_mean_2022
)

write.csv(common_countries_salaries,'common_countries_salaries.csv')

#3.2

#getting the count of jobs in each year

ind_job_count_2020<-c()
ind_job_count_2021<-c()
ind_job_count_2022<-c()
for (yr in c(2020,2021,2022)){
  for (job in unique(data_frame$job_title)){
    job_role_count<-nrow(filter(data_frame,work_year==yr,job_title==job))
    if (is.na(job_role_count)){job_role_count=0}
    if (yr==2020){
      ind_job_count_2020<-c(ind_job_count_2020,job_role_count)
    }
    if (yr==2021){
      ind_job_count_2021<-c(ind_job_count_2021,job_role_count)
    }
    if (yr==2022){
      ind_job_count_2022<-c(ind_job_count_2022,job_role_count)
    }
  }
}

job_role_count_data<-data.frame('Job Title'=unique(data_frame$job_title),
                                              '2020 Count'=ind_job_count_2020,
                                              '2021 Count'=ind_job_count_2021,
                                              '2022 Count'=ind_job_count_2022)

write.csv(job_role_count_data,'job_role_count_data.csv')
