#!/usr/bin/env python
# coding: utf-8

# In[1]:


#To import the required libraries
import pandas as pd


# In[2]:


#To change the working directory
import os


# In[3]:


#To get the current working directory
os.getcwd()


# In[4]:


#Change the working directory
os.chdir('G:/Fall 2020/George Mason University/AIT 580/Chapter 9 IDMA')


# In[5]:


os.getcwd()


# In[6]:


#Load the dataset into a data frame
Census = pd.read_csv("Census_2000_and_2010_Population__Villages.csv")


# In[7]:


#Display a few records from the dataframe created
Census.head(10)


# In[8]:


#To get to know how many how many rows and columns the data frame has
Census.shape


# In[9]:


#Drop the NaN column
Census.drop('Sub County', axis = 1, inplace=True)


# In[10]:


Census.head(10)


# In[11]:


Census.describe()


# In[12]:


#Drop Columns SUMLEV, State, Place
Census.drop(['SUMLEV','State','Place','FuncStat'],axis =1, inplace=True)


# In[13]:


Census.head(10)


# In[14]:


#Rename Columns
Census = Census.rename(columns={"Total Population April 1, 2000r":"Population2000","Total Population April 1, 2010":"Population2010"})


# In[15]:


Census


# In[16]:


#Groupby County - Use the .reset_index() to make the County as column again in the grouped dataframe
Census_grp = Census.groupby(["County"])[['Population2000','Population2010','Population Change Number','Population Change Percent']].sum().reset_index()


# In[17]:


Census_grp


# In[18]:


print(Census_grp)


# In[19]:


type(Census_grp)


# In[20]:


print(Census_grp.columns)


# In[21]:


#Census_grp.replace(to_replace = " & Steuben", value = "", inplace = True)
Census_grp['County'] = Census_grp['County'].str.replace(' & Steuben','')


# In[22]:


Census_grp['County'] = Census_grp['County'].str.replace(' & Erie','')


# In[23]:


Census_grp['County'] = Census_grp['County'].str.replace(' & Madison','')


# In[24]:


Census_grp['County'] = Census_grp['County'].str.replace(' & Wyoming','')


# In[25]:


Census_grp['County'] = Census_grp['County'].str.replace('cattaraugus','Cattaraugus')


# In[26]:


Census_grp['County'] = Census_grp['County'].str.replace('cattaraugus','Cattaraugus')


# In[27]:


Census_grp['County'] = Census_grp['County'].str.replace('cattaragus','Cattaraugus')


# In[28]:


Census_grp['County'] = Census_grp['County'].str.replace('chenango','Chenango')


# In[29]:


Census_grp['County'] = Census_grp['County'].str.replace(' & Herkimer','')


# In[30]:


Census_grp['County'] = Census_grp['County'].str.replace('Genesee & Wyoming','Genesse')


# In[31]:


Census_grp['County'] = Census_grp['County'].str.replace('Ontario & Yates','Ontario')


# In[32]:


Census_grp['County'] = Census_grp['County'].str.replace('Ontario & Yates','Ontario')


# In[33]:


Census_grp['County'] = Census_grp['County'].str.replace('ontario','Ontario')


# In[34]:


Census_grp['County'] = Census_grp['County'].str.replace('Genesse','Genesee')


# In[35]:


Census_grp


# In[36]:


#Groupby County - Use the .reset_index() to make the County as column again in the grouped dataframe
Census_grp2000 = Census_grp.groupby(["County"])[['Population2000','Population2010','Population Change Number', 'Population Change Percent']].sum().reset_index()


# In[37]:


Census_grp2000


# In[38]:


Census_grp2000.describe()


# In[39]:


#Correlation PLot
import matplotlib.pyplot as plt


# In[42]:


plt.matshow(Census_grp2000.corr())
plt.title("Correlation Plot of Census Data")
plt.show()


# In[43]:


import seaborn as sb


# In[47]:


sb.pairplot(Census_grp2000)


# In[49]:


#Scatter plot
sb.scatterplot(data = Census, x = 'Population2000', y = 'Population2010' )


# In[166]:


sb.scatterplot(data = Census, x = 'Population2000', y = 'Population2010' )


# In[52]:


p = sb.barplot(data = Census_grp2000, x = 'County', y = 'Population Change Number', color= 'Blue')
plt.xticks(rotation=90)
sb.set(rc = {'figure.figsize':(20,8)})
p.set_title("Population Change Pattern in the State of New York")


# In[ ]:




