import pandas as pd
import numpy as np
from sklearn.preprocessing import OneHotEncoder, LabelEncoder

data = pd.read_json('train.json')
n_samples = 2000
data = data.sample(n = n_samples)
data = data.dropna()
data.index = range(2000)

labels = []
for i in data.index:
  for k in range(len(data['ingredients'][i])):
    labels.append(data['ingredients'][i][k])

unique_labels = np.unique(labels)
new_data = pd.DataFrame(np.zeros([n_samples, len(unique_labels)]), columns = unique_labels)
new_data.shape
for raw in range(0, n_samples):
  for name in data['ingredients'][raw]:
    new_data.iloc[raw][name] = 1

new_data.index = data['id']
new_data.to_csv('dish_indredients_matrix.csv')
