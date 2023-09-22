# import pandas as pd
# import numpy as np
# import pickle
# from sklearn.preprocessing import LabelEncoder
# from sklearn.model_selection import train_test_split
# from sklearn.svm import SVC
# from sklearn.naive_bayes import GaussianNB
# from sklearn.ensemble import RandomForestClassifier
# from scipy.stats import mode

# # Load the dataset
# symptoms_data = HealthSymptom.objects.all().values()  # Query all data
# data = pd.DataFrame(symptoms_data)

# # Encode the target value into numerical value using LabelEncoder
# encoder = LabelEncoder()
# data["prognosis"] = encoder.fit_transform(data["prognosis"])

# # Split the data into training and testing sets
# X = data.drop("prognosis", axis=1)
# y = data["prognosis"]
# X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# # Train the models
# final_svm_model = SVC(probability=True)
# final_nb_model = GaussianNB()
# final_rf_model = RandomForestClassifier(random_state=18)

# final_svm_model.fit(X_train, y_train)
# final_nb_model.fit(X_train, y_train)
# final_rf_model.fit(X_train, y_train)

# # Evaluate the models on training data
# svm_train_accuracy = final_svm_model.score(X_train, y_train)
# nb_train_accuracy = final_nb_model.score(X_train, y_train)
# rf_train_accuracy = final_rf_model.score(X_train, y_train)

# # Evaluate the models on testing data
# svm_test_accuracy = final_svm_model.score(X_test, y_test)
# nb_test_accuracy = final_nb_model.score(X_test, y_test)
# rf_test_accuracy = final_rf_model.score(X_test, y_test)

# # Print the accuracies
# print("SVM Training Accuracy: ", svm_train_accuracy)
# print("Naive Bayes Training Accuracy: ", nb_train_accuracy)
# print("Random Forest Training Accuracy: ", rf_train_accuracy)

# print("SVM Testing Accuracy: ", svm_test_accuracy)
# print("Naive Bayes Testing Accuracy: ", nb_test_accuracy)
# print("Random Forest Testing Accuracy: ", rf_test_accuracy)

# # Save the models to disk
# pickle.dump(final_svm_model, open('final_svm_model.pkl', 'wb'))
# pickle.dump(final_nb_model, open('final_nb_model.pkl', 'wb'))
# pickle.dump(final_rf_model, open('final_rf_model.pkl', 'wb'))
# pickle.dump(encoder, open('encoder.pkl', 'wb'))