FROM mudgalK/train-schedule
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 9092
CMD [ "npm", "start" ]
