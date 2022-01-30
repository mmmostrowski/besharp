@echo off

docker build -t besharp .

cls

docker run -it --rm --volume %cd%:/besharp/ besharp

