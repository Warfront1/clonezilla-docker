# clonezilla-docker
Clonezilla live ISOs made available as Docker Images

## How to run the Docker container
Use the following command to run the Docker container:
```bash
docker run -it warfront1cz/clonezilla:latest
```

## Accessing Bash on the Clonezilla Container
By default, the container runs clonezilla.
If you wanted to run `bash` on the clonezilla container, you can use the following command:
```bash
docker run -it warfront1cz/clonezilla:latest /bin/bash
```

## Contributing
The following information is for maintainers or contributors who need to update or modify the Docker image.

## Updating the Clonezilla Version
This repository uses a GitHub Actions workflow to simplify updating to a new version of Clonezilla.

1.  **Find the ISO URL**: Go to the [Clonezilla Live Stable releases page](https://sourceforge.net/projects/clonezilla/files/clonezilla_live_stable/) and copy the link address for the desired `amd64.iso` file.

2.  **Run the Update Workflow**:
    *   Navigate to the [Manual Clonezilla Update](https://github.com/Warfront1/clonezilla-docker/actions/workflows/manual-update.yml) action.
    *   Click the **"Run workflow"** dropdown.
    *   Paste the ISO URL into the **"The URL of the Clonezilla ISO to update to"** field.
    *   Click the green **"Run workflow"** button.

3.  **Review and Merge**: The action will automatically create a new branch and open a pull request. Once the checks have passed, simply review and merge the PR. The main CI/CD pipeline will then build and publish the new Docker image.

## Additional Links
[DockerHub](https://hub.docker.com/r/warfront1cz/clonezilla)