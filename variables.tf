/*_____________________________________________________________________________________________________________________
Model Data from Top Level Module
_______________________________________________________________________________________________________________________
*/
variable "system_settings" {
  description = "System Settings Model data."
  type        = any
}


/*_____________________________________________________________________________________________________________________

Global Shared Variables
_______________________________________________________________________________________________________________________
*/


variable "annotations" {
  default = [
    {
      key   = "orchestrator"
      value = "terraform:easy-aci:v2.0"
    }
  ]
  description = "The Version of this Script."
  type = list(object(
    {
      key   = string
      value = string
    }
  ))
}

variable "apic_version" {
  default     = "5.2(4e)"
  description = "The Version of ACI Running in the Environment."
  type        = string
}


/*_____________________________________________________________________________________________________________________

System > System Settings: Global AES Encryption Setting — Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "aes_passphrase" {
  description = "Global AES Passphrase."
  sensitive   = true
  type        = string
}
