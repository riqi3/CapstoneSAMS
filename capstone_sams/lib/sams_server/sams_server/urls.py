# from rest_framework_simplejwt.views import (
#     TokenObtainPairView,
#     TokenRefreshView,
# )
from django.contrib import admin
from django.urls import path, include
# from api.views import PredictDisease, PatientView, MedicineView, SymptomsView, PersonalNotesView, CommentView
from api.modules.disease_prediction.cdssModel.views import PredictDisease
# from api.modules.drug.views import 
# process_pdf,  predict HealthRecordView,ViewUploadCSV, ViewLabResult

urlpatterns = [
    path('admin/', admin.site.urls),
    path('patient/', include('api.modules.patient.urls')),
    path('cpoe/', include('api.modules.cpoe.urls')),
    path('user/', include('api.modules.user.urls')),
    path('laboratory/', include('api.modules.laboratory.urls')),
    path('predict/', PredictDisease.as_view(), name='predict'),
 
    # path('upload/', include('api.modules.drug.urls')),
    

    # path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    # path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    # path('api/addDrug/', ViewUploadCSV, name='ViewUploadCSV'),
    # path('api/drugDetail/<int:pk>/', drug_detail, name='drug_detail'),
    # path('api/records/', HealthRecordView.fetch_records, name='fetch_records'),
    # path('api/records/<str:recordNum>', HealthRecordView.fetch_record_by_num, name='fetch_record'),
    # path('predict/<str:symptoms>', PredictDisease.get, name='predict'),
]
