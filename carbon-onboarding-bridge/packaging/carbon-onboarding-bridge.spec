Name:       carbon-onboarding-bridge
Summary:    Carbon onboarding gRPC bridge service
Version:    0.1.0
Release:    1
Group:      N/A
License:    MIT
Source0:    %{name}-%{version}.tar.gz
SOURCE1001: %{name}.manifest

%description
Temporary gRPC bridge service for Carbon onboarding. Provides ConfigService
and SetupService over a Unix domain socket, replacing carbon-config-service and
qr-code-setup until these services are merged into carbon-daemon.

Pre-built RPMs must be placed in tizen/rpm/sources/ before running gbs build:
  tizen/rpm/sources/%{name}-%{version}-%{release}.armv7l.rpm
  tizen/rpm/sources/%{name}-%{version}-%{release}.aarch64.rpm

%prep
%setup -q
cp %{SOURCE1001} .

%build

%install
%ifarch armv7l
unrpm tizen/rpm/sources/%{name}-%{version}-%{release}.armv7l.rpm
%endif

%ifarch aarch64
unrpm tizen/rpm/sources/%{name}-%{version}-%{release}.aarch64.rpm
%endif

mkdir -p %{buildroot}%{_bindir} \
         %{buildroot}/usr/lib/systemd/system \
         %{buildroot}/usr/lib/systemd/system/multi-user.target.wants

install -m 0755 usr/bin/%{name} %{buildroot}%{_bindir}/%{name}
install -m 0644 usr/lib/systemd/system/%{name}.service \
        %{buildroot}/usr/lib/systemd/system/%{name}.service
install -m 0644 usr/lib/systemd/system/carbon-daemon-config-watch.path \
        %{buildroot}/usr/lib/systemd/system/carbon-daemon-config-watch.path
install -m 0644 usr/lib/systemd/system/carbon-daemon-config-reload.service \
        %{buildroot}/usr/lib/systemd/system/carbon-daemon-config-reload.service

ln -sf /usr/lib/systemd/system/%{name}.service \
       %{buildroot}/usr/lib/systemd/system/multi-user.target.wants/%{name}.service
ln -sf /usr/lib/systemd/system/carbon-daemon-config-watch.path \
       %{buildroot}/usr/lib/systemd/system/multi-user.target.wants/carbon-daemon-config-watch.path

%post
systemctl daemon-reload || :
systemctl enable %{name}.service || :
systemctl start %{name}.service || :
systemctl enable carbon-daemon-config-watch.path || :
systemctl start carbon-daemon-config-watch.path || :

%preun
if [ "$1" = "0" ]; then
    systemctl stop carbon-daemon-config-watch.path || :
    systemctl disable carbon-daemon-config-watch.path || :
    systemctl stop %{name}.service || :
    systemctl disable %{name}.service || :
fi

%postun
systemctl daemon-reload || :

%files
%manifest %{name}.manifest
%defattr(-,root,root,-)
%{_bindir}/%{name}
/usr/lib/systemd/system/%{name}.service
/usr/lib/systemd/system/carbon-daemon-config-watch.path
/usr/lib/systemd/system/carbon-daemon-config-reload.service
/usr/lib/systemd/system/multi-user.target.wants/%{name}.service
/usr/lib/systemd/system/multi-user.target.wants/carbon-daemon-config-watch.path
