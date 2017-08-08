# === Class: teleport::install
#
# Installs teleport
class teleport::install(
  $use_repo    = false,
  $manage_repo = false,
) inherits teleport::params {
  if $use_repo {
    if $manage_repo {
      class {'teleport::repo':
        ensure        => present,
        repo_location => $teleport::params::repo_location,
        repos         => $teleport::params::repos,
        release       => $teleport::params::repo_release,
        key           => $teleport::params::repo_key,
      }
    }

    package {'teleport':
      ensure => $teleport::version,
    }
  } else {
    include ::archive

    file { $teleport::extract_path:
      ensure => directory,
    } ->
    archive { $teleport::archive_path:
      ensure       => present,
      extract      => true,
      extract_path => $teleport::extract_path,
      source       => "https://github.com/gravitational/teleport/releases/download/v${teleport::version}/teleport-v${teleport::version}-linux-amd64-bin.tar.gz",
      creates      => "${teleport::extract_path}/teleport"
    } ->
    file {
      "${teleport::bin_dir}/tctl":
        ensure => link,
        target => "${teleport::extract_path}/teleport/tctl";
      "${teleport::bin_dir}/teleport":
        ensure => link,
        target => "${teleport::extract_path}/teleport/teleport";
      "${teleport::bin_dir}/tsh":
        ensure => link,
        target => "${teleport::extract_path}/teleport/tsh";
      $teleport::assets_dir:
        ensure => link,
        target => "${teleport::extract_path}/teleport/app"
    }
  }
}
