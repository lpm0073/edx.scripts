#!/bin/bash
#---------------------------------------------------------
# written by: lawrence mcdaniel
#             https://lawrencemcdaniel.com
#             https://blog.lawrencemcdaniel.com
#
# date:       feb-2019
#
# usage:      edx.delete-course.sh list - generate a list of all courses
#             edx.delete-course.sh delete <Course ID>
#
#---------------------------------------------------------

cd /edx/app/edxapp/edx-platform

# delete a course
if [ $# == 2 ];
then
  if [ $1 == "delete" ];
  then
      sudo -u www-data /edx/bin/python.edxapp /edx/bin/manage.edxapp cms delete_course $2 --settings aws
      exit 1
  fi
# list courses
elif [ $# == 1 ];
then
    if [ $1 == "list" ];
    then
        sudo -u www-data /edx/bin/python.edxapp /edx/bin/manage.edxapp lms dump_course_ids --settings aws
        exit 1
    fi
fi

echo "edx.delete-course.sh list - generate a list of all courses"
echo "edx.delete-course.sh delete <Course ID>"
