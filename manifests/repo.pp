# Custom repo manage
class teleport::repo (
  $ensure         = false,
  $repo_location  = undef,
  $release        = $::lsbdistcodename,
  $repos          = undef,
  $key            = {},
){
  if($ensure == 'present' or $ensure == true) {
    case $::osfamily {
      'Debian': {
        include ::apt
        apt::source {'teleport':
          location => $repo_location,
          release  => $release,
          repos    => $repos,
          key      => $key,
        }
      }
      default: {
        fail("Unsupported managed repository for osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports managing repos for osfamily RedHat, Debian and Ubuntu")
      }
    }
  }
}
