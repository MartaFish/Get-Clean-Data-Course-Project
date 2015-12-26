# Get-Clean-Data-Course-Project
This is the course project results for the Getting and Cleaning Data Coursera Class

Preliminary steps:
The program starts by loading 2 packages, plyr and dplyr, which are used in the analysis. The utils packages is also loaded in case you wish to use the promptdata command at the end. The code to install these packages is also provided, however it has been labeled as text because these packages may already be loaded and this is the slowest step in running the program. 

Read and bind data:
It then reads in X data from both test and training and rbinds them into one file, with test being the first rows. The next step is to read in the features table and use those values as column names for the merged X data. It then reads in Y data from both test and training and rbinds them into one file. Like the X data, test is in the first rows. The y data is cbinded to the x data. The column formed by the Y data is renamed to "Activity." Finally it reads in the subject data from both test and training and rbind them into one file. As with X and Y, test is in the first rows. The subject data rbinded to the X & Y data. The resulting column is renamed "Subject".

Select only the relevant columns:
This data has several columns with duplicate names but different data. Further inspection indicates that none of these duplicate columns contain data with means or standard deviations. Since we are only interested in means and standard deviations, duplicate columns are removed. It then selects the columns for Activity, Subject, the variables which contain “mean” in the name, and variables containing “std” in the name. Variables containing “meanfreq” in the name were excluded as it did not seem to be a true measurement of a mean. We then decided that the measurements of means for a single axis were too granular in scale to be relevant to the current study and the analysis would be more relevant if only done on the aggregate data. Therefore, the program then does a second column selection to get rid of the means for a single axis, i.e. anything that ends with X, Y, or Z.

Renaming to make it more readable:
The activity labels were read in from the file and used to relabel the numbers in the Activity column. All of the variables columns were renamed with more descriptive labels. 

Create the tidydata file:
It uses ddply to summarize the data by subject and activity and calculate the mean for each variable. It then writes the table into a .txt file. Instructions to read the table and create some background codebook data are at the end of the analysis, however they have been labeled as text so that you can choose if you wish to do this.

