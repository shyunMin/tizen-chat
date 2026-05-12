Name:       carbon-onboarding-bridge
Summary:    Carbon onboarding gRPC bridge service
Version:    0.1.0
Release:    1
Group:      N/A
License:    MIT
Source0:    %{name}-%{version}.tar.gz
Source1001: %{name}.manifest

%description
Temporary gRPC bridge service for Carbon onboarding. Provides ConfigService
and SetupService over a Unix domain socket, replacing carbon-config-service and
qr-code-setup until these services are merged into carbon-daemon.

The binary must be cross-compiled before running gbs build:
  armv7l:  cargo build --release --target armv7-unknown-linux-gnueabihf
  aarch64: cargo build --release --target aarch64-unknown-linux-gnu
Then copy the binary to tizen/rpm/sources/ (see build.sh).

%prep
%setup -q
cp %{SOURCE1001} .

%build
# Binary is cross-compiled outside GBS; no build step needed here.

%install
rm -rf %{buildroot}

%ifarch armv7l
install -Dm0755 tizen/rpm/sources/%{name} \
        %{buildroot}%{_bindir}/%{name}
%endif

%ifarch aarch64
install -Dm0755 tizen/rpm/sources/%{name}.aarch64 \
        %{buildroot}%{_bindir}/%{name}
%endif

mkdir -p %{buildroot}%{_unitdir} \
         %{buildroot}%{_unitdir}/multi-user.target.wants

install -Dm0644 packaging/%{name}.service \
        %{buildroot}%{_unitdir}/%{name}.service
install -Dm0644 packaging/carbon-daemon-config-watch.path \
        %{buildroot}%{_unitdir}/carbon-daemon-config-watch.path
install -Dm0644 packaging/carbon-daemon-config-reload.service \
        %{buildroot}%{_unitdir}/carbon-daemon-config-reload.service

ln -sf %{_unitdir}/%{name}.service \
       %{buildroot}%{_unitdir}/multi-user.target.wants/%{name}.service
ln -sf %{_unitdir}/carbon-daemon-config-watch.path \
       %{buildroot}%{_unitdir}/multi-user.target.wants/carbon-daemon-config-watch.path

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
%{_unitdir}/%{name}.service
%{_unitdir}/carbon-daemon-config-watch.path
%{_unitdir}/carbon-daemon-config-reload.service
%{_unitdir}/multi-user.target.wants/%{name}.service
%{_unitdir}/multi-user.target.wants/carbon-daemon-config-watch.path
