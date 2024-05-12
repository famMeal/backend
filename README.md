# README

BACKEND notes

To start the backend with byebug enabled. Go to the backend folder.
// Detached docker container
docker-compose up -d

// Get the name of the container
docker container ls

// Attach it
docker attach [container_id]

To build the backend
docker-compose build

To run commands on the backend
docker-compose run web ...
docker-compose run web rails db:create
docker-compose run web rails db:migrate
docker-compose run web rails db:seed


FRONTEND notes

Start the frontend

yarn start
