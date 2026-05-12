Name:           carbon-onboarding-bridge
Version:        0.1.0
Release:        1%{?dist}
Summary:        cargo-tizen generated RPM package for carbon-onboarding-bridge
License:        LicenseRef-Unknown
BuildArch:      %{_target_cpu}
Source0:        carbon-onboarding-bridge
Source1:        carbon-onboarding-bridge.service
Source2:        carbon-daemon-config-watch.path
Source3:        carbon-daemon-config-reload.service

%description
Starter RPM spec for the `carbon-onboarding-bridge` binary.

%prep

%build

%install
install -Dm0755 %{SOURCE0} %{buildroot}%{_bindir}/%{name}

mkdir -p %{buildroot}/usr/lib/systemd/system \
         %{buildroot}/usr/lib/systemd/system/multi-user.target.wants

install -Dm0644 %{SOURCE1} %{buildroot}/usr/lib/systemd/system/%{name}.service
install -Dm0644 %{SOURCE2} %{buildroot}/usr/lib/systemd/system/carbon-daemon-config-watch.path
install -Dm0644 %{SOURCE3} %{buildroot}/usr/lib/systemd/system/carbon-daemon-config-reload.service

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
%{_bindir}/%{name}
/usr/lib/systemd/system/%{name}.service
/usr/lib/systemd/system/carbon-daemon-config-watch.path
/usr/lib/systemd/system/carbon-daemon-config-reload.service
/usr/lib/systemd/system/multi-user.target.wants/%{name}.service
/usr/lib/systemd/system/multi-user.target.wants/carbon-daemon-config-watch.path
