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




resource "google_compute_network" "securenetwork" {
	name = "securenetwork"
	auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "securenetwork" {
	name          = "securenetwork"
	region        = "us-central1"
	network       = google_compute_network.securenetwork.self_link
	ip_cidr_range = "10.130.0.0/20"
}

resource "google_compute_firewall" "bastionbost-allow-rdp" {
	name = "bastionbost-allow-rdp"
	network = google_compute_network.securenetwork.self_link
	target_tags = ["bastion"]
	allow {
		protocol = "tcp"
		ports    = ["3389"]
	}
}

resource "google_compute_firewall" "securenetwork-allow-rdp" {
	name = "securenetwork-allow-rdp"
	network = google_compute_network.securenetwork.self_link
	source_ranges = ["10.130.0.0/20"]
	allow {
		protocol = "tcp"
		ports    = ["3389"]
	}
}

module "vm-securehost" {
	source           = "./securehost"
	instance_name    = "vm-securehost"
	instance_zone    = "us-central1-a"
	instance_tags = "secure"
	instance_subnetwork = google_compute_subnetwork.securenetwork.self_link
}

module "vm-bastionhost" {
	source           = "./bastionhost"
	instance_name    = "vm-bastionhost"
	instance_zone    = "us-central1-a"
	instance_tags = "bastion"
	instance_subnetwork = google_compute_subnetwork.securenetwork.self_link
}
