from django.db import models
from django.conf import settings
from django.contrib import admin

class Professor(models.Model):
    organization = models.CharField(max_length=255,blank=True)
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)

    def __str__(self):
        return f'{self.user.first_name} {self.user.last_name}'
    
    @admin.display(ordering='user__first_name')
    def first_name(self):
        return self.user.first_name
    
    @admin.display(ordering='user__last_name')
    def last_name(self):
        return self.user.last_name
    
    class Meta:
        ordering = ['user__first_name','user__last_name']

class Subject(models.Model):
    name = models.CharField(max_length=255)
    professor = models.ForeignKey(Professor, on_delete=models.CASCADE,related_name='subject')

    def __str__(self):
        return self.name
    
    class Meta:
        ordering = ['name',]

class Lecture(models.Model):
    name = models.CharField(max_length=255)
    subject = models.ForeignKey(Subject, on_delete=models.CASCADE,related_name='lecture')
    created_at = models.DateTimeField(auto_now_add=True)
    islive = models.BooleanField(default=True)

    def __str__(self):
        return self.name
    
    class Meta:
        ordering = ['name',]

class Student(models.Model):
    id = models.CharField(max_length=10,primary_key=True)
    fullname = models.CharField(max_length=255)
    lecture = models.ManyToManyField(Lecture, related_name='student', blank=True)

    def __str__(self):
        return self.fullname
    
    class Meta:
        ordering = ['fullname',]

class Device(models.Model):
    unique_id = models.CharField(max_length=255,db_index=True,unique=True)
    Student = models.ForeignKey('Student', on_delete=models.CASCADE,blank=True,null=True)
