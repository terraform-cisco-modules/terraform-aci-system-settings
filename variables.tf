/*_____________________________________________________________________________________________________________________

Model Data from Top Level Module
_______________________________________________________________________________________________________________________
*/
variable "system_settings" {
  description = "System Settings YAML Model data."
  type        = any
}


/*_____________________________________________________________________________________________________________________

System Settings Sensitive Variables
_______________________________________________________________________________________________________________________
*/
variable "system_sensitive" {
  default = {
    global_aes_encryption_settings = {
      passphrase = {}
    }
  }
  description = <<EOT
    Note: Sensitive Variables cannot be added to a for_each loop so these are added seperately.
    * mcp_instance_policy_default: MisCabling Protocol Instance Settings.
      - key: The key or password used to uniquely identify this configuration object.
    * virtual_networking: ACI to Virtual Infrastructure Integration.
      - password: Username/Password combination to Authenticate to the Virtual Infrastructure.
  EOT
  sensitive   = true
  type = object({
    global_aes_encryption_settings = object({
      passphrase = map(string)
    })
  })
}
