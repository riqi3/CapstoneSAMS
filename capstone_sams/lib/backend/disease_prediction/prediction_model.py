import numpy as np
import pandas as pd
from sklearn.svm import SVC
from sklearn.naive_bayes import GaussianNB
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import accuracy_score, f1_score
from scipy.stats import mode
from joblib import dump, load

# Loading the datasets
df_train = pd.read_csv('training.csv')
df_test = pd.read_csv('testing.csv')

# Data preprocessing
X_train = df_train.iloc[:, :-1]
y_train = df_train['prognosis']

X_test = df_test.iloc[:, :-1]
y_test = df_test['prognosis']

# Encoding string values into numeric values
le = LabelEncoder()
y_train = le.fit_transform(y_train)
y_test = le.transform(y_test)  # Use same encoder to transform test targets

# Create symptom index mapping
symptom_index = {symptom: index for index, symptom in enumerate(df_train.columns[:-1])}

# Create prediction classes mapping
predictions_classes = le.classes_

# Combine both in a dictionary
data_dict = {"symptom_index": symptom_index, "predictions_classes": predictions_classes}

# Training the models
final_svm_model = SVC()
final_nb_model = GaussianNB()
final_rf_model = RandomForestClassifier(random_state=18)

final_svm_model.fit(X_train, y_train)
final_nb_model.fit(X_train, y_train)
final_rf_model.fit(X_train, y_train)

# Save the models
dump(final_svm_model, 'svm_model.joblib')
dump(final_nb_model, 'nb_model.joblib')
dump(final_rf_model, 'rf_model.joblib')

# Save the data dictionary
dump(data_dict, 'data_dict.joblib')

# Load the models
svm_model = load('svm_model.joblib')
nb_model = load('nb_model.joblib')
rf_model = load('rf_model.joblib')

# Predict disease function
def predict_disease(symptoms):
    data_dict = load('data_dict.joblib')
    input_data = [0] * len(data_dict["symptom_index"])
    
    for symptom in symptoms:
        index = data_dict["symptom_index"][symptom]
        input_data[index] = 1

    input_data = np.array(input_data).reshape(1,-1)
    
    # generating individual outputs
    rf_prediction = data_dict["predictions_classes"][svm_model.predict(input_data)[0]]
    nb_prediction = data_dict["predictions_classes"][nb_model.predict(input_data)[0]]
    svm_prediction = data_dict["predictions_classes"][rf_model.predict(input_data)[0]]
    
    # making final prediction by taking mode of all predictions
    final_prediction = mode([rf_prediction, nb_prediction, svm_prediction])[0][0]
    
    return final_prediction
