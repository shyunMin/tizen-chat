Name:       org.tizen.chat-ui
Summary:    org.tizen.chat-ui
Version:    1.0.4
Release:    1
Group:      N/A
License:    Apache-2.0
Source0:    %{name}-%{version}.tar.gz
SOURCE1001: carbon-onboarding-bridge.manifest

BuildRequires:  pkgconfig(libtzplatform-config)

%define internal_name org.tizen.chat-ui
%define preload_tpk_path %{TZ_SYS_RO_APP}/.preload-tpk
%define bridge_name carbon-onboarding-bridge

%description
This application is used to talk with ai of the system.
Includes carbon-onboarding-bridge: Temporary gRPC bridge service for Carbon onboarding.
Provides ConfigService and SetupService over a Unix domain socket, replacing
carbon-config-service and qr-code-setup until these services are merged into carbon-daemon.

%prep
%setup -q
cp %{SOURCE1001} .

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/%{preload_tpk_path}

# Install TPK and carbon-onboarding-bridge from pre-built RPM
%ifarch %{arm}
install packaging/arm/%{internal_name}-%{version}.tpk %{buildroot}/%{preload_tpk_path}/
# unrpm packaging/arm/%{bridge_name}-0.1.0-1.armv7l.rpm
%else
install packaging/arm64/%{internal_name}-%{version}.tpk %{buildroot}/%{preload_tpk_path}/
# unrpm packaging/arm64/%{bridge_name}-0.1.0-1.aarch64.rpm
%endif

# mkdir -p %{buildroot}%{_bindir}
# mkdir -p %{buildroot}/usr/lib/systemd/system
# mkdir -p %{buildroot}/usr/lib/systemd/system/multi-user.target.wants

# install -m 0755 usr/bin/%{bridge_name} %{buildroot}%{_bindir}/%{bridge_name}
# install -m 0644 usr/lib/systemd/system/%{bridge_name}.service %{buildroot}/usr/lib/systemd/system/%{bridge_name}.service      
# install -m 0644 usr/lib/systemd/system/carbon-daemon-config-watch.path %{buildroot}/usr/lib/systemd/system/carbon-daemon-config-watch.path
# install -m 0644 usr/lib/systemd/system/carbon-daemon-config-reload.service %{buildroot}/usr/lib/systemd/system/carbon-daemon-config-reload.service

# ln -sf /usr/lib/systemd/system/%{bridge_name}.service %{buildroot}/usr/lib/systemd/system/multi-user.target.wants/%{bridge_name}.service
# ln -sf /usr/lib/systemd/system/carbon-daemon-config-watch.path %{buildroot}/usr/lib/systemd/system/multi-user.target.wants/carbon-daemon-config-watch.path

%files
%defattr(-,root,root,-)
%{preload_tpk_path}/*
%license LICENSE
# %manifest %{bridge_name}.manifest
# %{_bindir}/%{bridge_name}
# /usr/lib/systemd/system/%{bridge_name}.service
# /usr/lib/systemd/system/multi-user.target.wants/%{bridge_name}.service
# /usr/lib/systemd/system/carbon-daemon-config-watch.path
# /usr/lib/systemd/system/carbon-daemon-config-reload.service
# /usr/lib/systemd/system/multi-user.target.wants/carbon-daemon-config-watch.path