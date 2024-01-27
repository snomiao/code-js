```bash
# check cpu arch
arch
# or
uname -m

# check gpu status
nvidia-smi

# If the system doesn't have an NVIDIA GPU or NVIDIA drivers installed, this command won't work.
# For checking GPU status with other types of GPUs, you can use:

lspci | grep VGA

# For a more detailed view, you might need to rely on specific tools provided by the GPU manufacturer or use generic tools like:
# This requires the `mesa-utils` package on Debian-based systems. install it by:
apt-get -y install mesa-utils

glxinfo | grep -i 'device'


# This command will list the sizes of all the top-level directories in the root ('/') directory.
# Use `-h` to get the sizes in a human-readable format, and `-s` to summarize the contents for each argument.

```