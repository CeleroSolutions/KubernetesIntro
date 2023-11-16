# Kubernetes Load Generator Demo

This project is an ASP.NET Core 8.0 API designed to generate load for testing Kubernetes autoscaling. The API calculates the 50,000th prime number and serves as a workload for evaluating the scalability of your Kubernetes cluster.

## Getting Started

### Prerequisites

- Docker: Ensure that you have Docker installed on your machine. You can download Docker from [here](https://www.docker.com/get-started).

### Running the Application

1. Pull the Docker image from Docker Hub:

    ```bash
    docker pull celerosolutions/kubernetesloadgeneratordemo
    ```

2. Run the Docker container:

    ```bash
    docker run -p 8080:8080 celerosolutions/kubernetesloadgeneratordemo
    ```

    This will start the API and make it accessible on port 8080.

3. Access the API:

    Open your web browser or use a tool like curl to access the following endpoint:

    ```plaintext
    http://localhost:8080/findPrime
    ```

    This endpoint calculates the 50,000th prime number.

## Testing Kubernetes Autoscaling

Deploy this API in your Kubernetes cluster to simulate a workload and test the autoscaling capabilities. Adjust the number of replicas and monitor the behavior of your cluster as the load increases.

## API Documentation

Swagger documentation is available for this API. After running the application, you can access Swagger UI at:

```plaintext
http://localhost:8080/swagger
```

This will provide a detailed overview of the API endpoints and their descriptions.

## Dockerfile

The Dockerfile included in this project facilitates the building and running of the ASP.NET Core API within a Docker container. Customize the Dockerfile as needed for your specific requirements.