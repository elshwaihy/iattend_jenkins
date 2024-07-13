from django.contrib import admin
from . import models

@admin.register(models.Professor)
class ProfessorAdmin(admin.ModelAdmin):
    list_display = ('first_name','last_name','organization',)
    list_editable = ('organization',)
    list_per_page = 10
    list_select_related = ('user',)
    ordering = ('user__first_name','user__last_name')
    search_fields = ('first_name__istartswith', 'organization__istartswith',)
    list_filter = ('organization',)

@admin.register(models.Subject)
class SubjectAdmin(admin.ModelAdmin):
    list_display = ('name', 'professor',)
    ordering = ('name',)
    list_per_page = 10
    search_fields = ('name__istartswith', 'firstname__istartswith',)
    list_filter = ('professor',)

@admin.register(models.Lecture)
class LectureAdmin(admin.ModelAdmin):
    list_display = ('name', 'subject', 'created_at', 'islive')
    ordering = ('name',)
    list_per_page = 10
    search_fields = ('name__istartswith', 'subject__name__istartswith',)
    list_filter = ('subject',)

@admin.register(models.Student)
class StudentAdmin(admin.ModelAdmin):
    list_display = ('id', 'fullname', )
    ordering = ('fullname',)
    list_per_page = 10
    search_fields = ('fullname__istartswith',)
    list_filter = ('lecture',)

@admin.register(models.Device)
class DeviceAdmin(admin.ModelAdmin):
    list_display = ('unique_id',)
    ordering = ('unique_id',)
    list_per_page = 10
