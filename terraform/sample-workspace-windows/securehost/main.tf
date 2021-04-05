# Copyright 2021 "Holloway" Chew, Kean Ho <hollowaykeanho@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.




variable "instance_name" {
}
variable "instance_zone" {
	default = "us-central1-a"
}
variable "instance_type" {
	default = "n1-standard-1"
}
variable "instance_subnetwork" {
}
variable "instance_tags" {
}

resource "google_compute_instance" "vm_instance" {
	name         = var.instance_name
	zone         = var.instance_zone
	machine_type = var.instance_type
	tags = [var.instance_tags]
	boot_disk {
		initialize_params {
			image = "windows-cloud/windows-2016"
		}
	}
	network_interface {
		subnetwork = var.instance_subnetwork
	}
	network_interface {
		subnetwork = "default"
	}
}
