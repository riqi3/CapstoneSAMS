from django.contrib import admin
from django.urls import path, include
urlpatterns = [
    path('admin/', admin.site.urls),
    path('patient/', include('api.modules.patient.urls')),
    path('cpoe/', include('api.modules.cpoe.urls')),
    path('user/', include('api.modules.user.urls')),
    path('laboratory/', include('api.modules.laboratory.urls')),
    path('cdss/', include('api.modules.disease_prediction.cdssModel.urls')),
    path('diagnostics/', include('api.modules.disease_prediction.diagnosticModel.urls')),
]
