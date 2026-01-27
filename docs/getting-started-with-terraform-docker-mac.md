
Getting Started with Terraform (Docker, Mac, IaC)
==

In this article, I will show you how to get started with Terraform.

**Terraform** is an **Infrastructure-as-Code** (**IaC**) tool. It lets you write and run code to automate the installation and configuration of your localhost or cloud environments.

> **Info:** These instructions were written and tested on a Mac.


## Step 1. Install Terraform

You can find Terraform install instructions for Mac, Windows, and Linux here:

-   [https://developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/downloads?ref=scriptable.com)

I followed the instructions for using **brew** to install it on my Mac.

> **Info:** If you are on a Mac and don't have brew installed, see the instructions here: [https://brew.sh](https://brew.sh/?ref=scriptable.com)


On a Mac, you can install Terraform like this:

```sh
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

### Check the version

To check the version, run this command:

```sh
terraform version 
```

If you get a warning that your version is out of date, ignore the instructions to download and do this instead:

```sh
brew upgrade terraform
```

## Step 2. Run Docker

To run Docker on a Mac, run this command from a terminal window:

```sh
open -a Docker
```

## Step 3. Create a project folder

To create a project folder, run these commands:

```sh
mkdir ~/projects/terraform/terraform-docker-101
cd ~/projects/terraform/terraform-docker-101
```

## Step 4.  Create a main.tf file

**Terraform** works by reading **\*.tf** files. Those files contain declarative statements defining the cloud infrastructure that you would like to build.  By default, it looks for a file called **main.tf** .

-   Create a file called **main.tf** in the root of your project:

```sh
touch main.tf
```

-   Open **main.tf** in an IDE like Visual Studio Code (VS Code)
-   If VS Code prompts you about extensions to support the **\*.tf** file, go ahead and install them

## Step 5. Declare a provider

For this example, we're going to be working with Docker.  So we can specify the use of a Docker **_provider_**.

In Terraform you can think of a provider as a plugin, that provides extra third-party resource types and data sources. You can use them to define your infrastructure.

To use the recommended Docker provider, add this to the top of **main.tf** and save it:

```tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.1"
    }
  }
}

provider "docker" {
  host = var.docker_endpoint
}
```

I've provided a link to the documentation for that provider in the reference section at the end of this article.

### Adding variables

In the declaration above, the host is set to a variable name (**var.docker\_endpoint**).  

To add that variable do the following:

-   Create a new file in the project called **variables.tf**
-   Paste this into that new file and save it:

```tf
variable "docker_endpoint" {
  default = "unix:///var/run/docker.sock"
}
```

When you run the plan, that variable will be used to set the docker host provider host value.  Don't worry if it doesn't look correct.  I will show you in the next step how to override the default value.

## Step 6. Determine the docker context

The default docker endpoint value passed to the provider host may or may not be correct. Run this command to determine the correct one:

```sh
docker context ls
```

Look for the **_NAME_** that has a star (**_\*_**) next to it.  That's the **_current_** context.  

Copy the current context **DOCKER ENDPOINT** from its column.

If you are using Docker Desktop it would be something like this (substituting my username for yours):

```sh
 unix:///Users/mitch/.docker/run/docker.sock
```

That's not very generic. You would need to do something like this, to work on other users' machines:

```sh
export TF_VAR_docker_endpoint=unix://$HOME/.docker/run/docker.sock

echo $TF_VAR_docker_endpoint
```

By starting the name with **TF\_VAR\_** it will be seen by Terraform as an override for **var.docker\_endoint**.

That is as long as you are working in the same terminal window.  If you wanted to make the setting permanent you could add it to your shell profile or write a bash script.  But that's beyond the scope of this article.  

Just beware that for this simple test, if you close the terminal window, or open a different one, the exported value (**TF\_VAR\_docker\_endpoint**) may not be set.

## Step 7. Pull an image with Terraform

To pull a Docker image using Terraform, append this declarative block to **main.tf** and save it:

```tf
# Create a docker image resource
# -> docker pull mitchallen/random-server:latest
resource "docker_image" "random" {
  name         = "mitchallen/random-server:latest"
  keep_locally = false
}
```

The **docker\_image** resource is provided by the docker provider declared in the previous step.

You can use any docker image that you would like.  For this example, I just used one of mine (you can find a link to the details in the references section).

The **keep\_locally** flag tells Terraform whether or not to keep the image locally when done.  I set it to false to remove it and free up resources when it's not in use.  It simply means that if you want to use it again, somewhere behind the scenes it will need to be pulled down to your local system by docker again.

I put in the comment above the resource declaration the equivalent docker command-line call.

## Step 8. Create a container from the image

To create a Docker container from the image, append this block to **main.tf** and save it:

```tf
# Create a docker container resource
# -> same as 'docker run --name random -p1220:3100 mitchallen/random-server:latest'
resource "docker_container" "random" {
  image = docker_image.random.image_id
  name  = "random"
  ports {
    internal = 3100
    external = 1220
  }
}
```

-   Notice how the block references the previous block with:
-   **image = docker\_image.random.image\_id**

I put in the comment above the call the equivalent docker command.

-   The declaration shows how to use the **docker\_container** resource (from the docker provider) to map the **internal** port (3100) to an **external** port (1220)

Save the file and move on to the next step.

## Step 9. Terraform init

The first thing you should always do with a new Terraform project is run this command (once):

```
terraform init
```

The command does several things to initialize the current directory to work with Terraform.  For more information on the command, see the references section.

## Step 10. Format the \*.tf file

To format the **main.tf** file, do the following:

-   Save all files in your project
-   Run this command:

```sh
terraform fmt
```

It's an optional step that can keep your code clean and consistent.

## Step 11. Run the plan

Once you've saved all the files, it's time to make a Terraform **_plan_**.  Think of it as a **_dry run_**.  Terraform parses your **\*.tf** file(s) to determine how to build the infrastructure that you've defined.  Or it may fail with an error - like if your docker host is incorrect.

Run this command to see if a plan can be generated successfully.

```sh
terraform plan
```

If you get an error regarding docker: either docker isn't running, or you need to try a different docker endpoint passed to the provider.

You may see a warning like this:

```sh
Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

You can get by for this demo without creating an **out** file.  But eventually, you should learn how to use them.

## Step 12. Apply the plan

To actually make the changes, run this command:

```sh
terraform apply
```

When prompted, type Yes to agree to apply the plan.

## Step 13. Check the results

To check the results you can do the following:

-   Verify that the image was downloaded for docker with this command:

```sh
 docker images | grep mitchallen
```

-   Verify that the container was created with this command:

```sh
docker ps
```

-   Verify that you see a container named **_random_**, which was created just a few minutes ago.
-   Verify that the server works, by running this command:

```sh
curl localhost:1220
```

## Step 14. Generate a graph

Terraform has a **graph** command that can be used to create a visual representation of the plan. It does this by generating **DOT** code.

Run this command to see an example of the generated DOT code:

```sh
terraform graph -type=plan
```

### Install dot

To turn the output of the graphic command into a picture, you need to install the special **dot** cli tool. For a Mac, you would do it like this:

```sh
brew install graphviz
```

For other operating systems, use this link to find install instructions:

-   [https://graphviz.org/download/](https://graphviz.org/download/?ref=scriptable.com)

### Generate a plan picture

Once the dot utility is installed, you can pipe the instructions through it to turn the plan into a picture.

Run this command to:

-   Turn the plan into **dot** code
-   Pipe it through the dot utility and  
-   Open and view the result

```sh
terraform graph -type=plan | dot -Tpng > plan.png

open plan.png
```

## Step 15. Cleanup

When you are done experimenting, Terraform makes it very easy to clean up.

You can remove the container and image by running this command:

```sh
terraform destory
```

-   Type **yes** when asked to confirm

### Verify cleanup

Run this command to verify the container was removed:

```sh
docker ps
```

Run this command to verify the image was removed too:

```sh
docker image ls
```

## Step 16. Add .gitignore

The makers of Terraform have posted an example .gitignore file, which you can copy from here:

-   [https://github.com/hashicorp/terraform-guides/blob/master/.gitignore](https://github.com/hashicorp/terraform-guides/blob/master/.gitignore?ref=scriptable.com)

To use it:

-   Create a new file called **.gitignore** in the root of your project
-   Copy the contents from the file in the link to your **.gitignore** file and save it

## Example repo

You can find the example repo here:

-   [https://github.com/mitchallen/terraform-101](https://github.com/mitchallen/terraform-101?ref=scriptable.com)

## Conclusion

In this article, you learned how to:

-   Install Terraform on a Mac
-   Define an Infrastructure as Code (IaC)
-   Use Terraform to manage docker instances
-   Initiate, plan, and apply a Terraform project
-   Pass and use environment variables in Terraform
-   Create a visual representation of a Terraform plan
-   Clean up using a simple command

## References

-   developer.hashicorp.com/terraform - \[[1](https://developer.hashicorp.com/terraform?ref=scriptable.com)\]
-   developer.hashicorp.com/terraform/downloads - \[[2](https://developer.hashicorp.com/terraform/downloads?ref=scriptable.com)\]
-   registry.terraform.io/providers/kreuzwerker/docker/latest/docs -\[[3](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs?ref=scriptable.com)\]
-   developer.hashicorp.com/terraform/language/providers - \[[4](https://developer.hashicorp.com/terraform/language/providers?ref=scriptable.com)\]
-   registry.terraform.io/providers/kreuzwerker/docker/latest/docs - \[[5](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs?ref=scriptable.com)\]
-   ../providers/kreuzwerker/docker/latest/docs/resources/image - \[[6](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/image?ref=scriptable.com)\]
-   hub.docker.com/r/mitchallen/random-server - \[[7](https://hub.docker.com/r/mitchallen/random-server?ref=scriptable.com)\]
-   ../providers/kreuzwerker/docker/latest/docs/resources/container - \[[8](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container?ref=scriptable.com)\]
-   developer.hashicorp.com/terraform/cli/commands/init - \[[9](https://developer.hashicorp.com/terraform/cli/commands/init?ref=scriptable.com)\]
-   developer.hashicorp.com/terraform/cli/commands/fmt - \[[10](https://developer.hashicorp.com/terraform/cli/commands/fmt?ref=scriptable.com)\]
-   docs.docker.com/engine/context/working-with-contexts/ - \[[11](https://docs.docker.com/engine/context/working-with-contexts/?ref=scriptable.com)\]
-   developer.hashicorp.com/terraform/cli/commands/graph - \[[12](https://developer.hashicorp.com/terraform/cli/commands/graph?ref=scriptable.com)\]
-   en.wikipedia.org/wiki/DOT\_(graph\_description\_language) - \[[13](https://en.wikipedia.org/wiki/DOT_(graph_description_language)?ref=scriptable.com)\]
-   graphviz.org/doc/info/lang.html - \[[14](https://graphviz.org/doc/info/lang.html?ref=scriptable.com)\]
-   graphviz.org/ - \[[15](see: https://graphviz.org/)\]
-   hieven.github.io/terraform-visual/ - \[[16](https://hieven.github.io/terraform-visual/?ref=scriptable.com)\] - an alternate way to visualize a plan