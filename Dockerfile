FROM mageai/mageai:latest

ARG USER_CODE_PATH=/home/src/magic

# Note: this overwrites the requirements.txt file in your new project on first run. 
# You can delete this line for the second run :) 
COPY ./requirements.txt ${USER_CODE_PATH}requirements.txt 

RUN pip install -r ${USER_CODE_PATH}requirements.txt