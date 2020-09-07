rm(list = ls())

library(xlsx)
library(ggplot2)
library(data.table)
library(ggthemes)

#importing input data ----
input_data <- read.xlsx("C:/Users/USER/Desktop/rcb_data.xlsx", sheetName = "data")

#converting to data.table
input_data <- as.data.table(input_data)

#exploring imported data ---
View(input_data)
head(input_data)
str(input_data)

#clean data - 
#changing col names
input_data <- setnames(input_data, c("Repo.rate.", "Non.food.Credit.",
                                     "Credit.to.Service.Sector.", "Credit.to.industry",
                                     "Personal.loan"), c("Repo Rate", "Non-Food Credit",
                                                         "Credit to Service Sector",
                                                         "Credit to Industry", "Personal Loan"))

#exploratory data analysis - EDA ----
summary(input_data)
hist(input_data$Credit.to.Service.Sector.)
hist(log10(input_data$Credit.to.Service.Sector.))
boxplot(input_data$Personal.loan)
boxplot(input_data$Credit.to.Service.Sector.)

#charts and plots using ggplot2 ----
#prepare the data to use for plotting
data_plot <- melt(input_data, id.vars = "Date", variable.name = "ind", 
                  value.name = "values")

#exploring the data via line charts
plot <- ggplot(data_plot, aes(x=Date, y = values, color=ind))+
  geom_line()

#dropping IIP since its skewed in 2020
data_plot <- data_plot[ind !="IIP",]



#proper plot
plot <- ggplot(data_plot, aes(x=Date, y = values, color = ind))+
  geom_line(size=1)+
  ylab("%")+
  xlab("")
  
plot <- plot + theme_bw() + facet_wrap(~ind, scales = "free") + 
  theme(legend.position = "none")+
  scale_colour_brewer(palette = "Dark2")+
  ggtitle("RBI rate cuts unable to increase credit flow",
          subtitle = "Personal loan growth at lowest point since 2017")

ggsave("C:/Users/USER/Desktop/crflw.jpeg", plot)
