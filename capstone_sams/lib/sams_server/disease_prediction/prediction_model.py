# prediction_model.py
import pandas as pd
import numpy as np
import pickle
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
from sklearn.naive_bayes import GaussianNB
from sklearn.ensemble import RandomForestClassifier
from scipy.stats import mode

# Load the training and testing datasets
train_data = pd.read_csv("Training.csv").dropna(axis = 1)
test_data = pd.read_csv("Testing.csv").dropna(axis = 1)

# Encode the target value into numerical value using LabelEncoder
encoder = LabelEncoder()
train_data["prognosis"] = encoder.fit_transform(train_data["prognosis"])
test_data["prognosis"] = encoder.transform(test_data["prognosis"])  # Use the same encoder to transform test data

# Split the data
X_train = train_data.iloc[:, :-1]
y_train = train_data.iloc[:, -1]

X_test = test_data.iloc[:, :-1]
y_test = test_data.iloc[:, -1]

# Train the models
final_svm_model = SVC()
final_nb_model = GaussianNB()
final_rf_model = RandomForestClassifier(random_state=18)

# final_svm_model.fit(X_train, y_train)
# final_nb_model.fit(X_train, y_train)
# final_rf_model.fit(X_train, y_train)

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
