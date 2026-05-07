Name:       org.tizen.chat-ui
Summary:    org.tizen.chat-ui
Version:    1.0.1
Release:    1
Group:      N/A
License:    Apache-2.0
Source0:    %{name}-%{version}.tar.gz

BuildRequires:  pkgconfig(libtzplatform-config)

%define internal_name org.tizen.chat-ui
%define preload_tpk_path %{TZ_SYS_RO_APP}/.preload-tpk

%description
This application is used to talk with ai of the system.

%prep
%setup -q

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/%{preload_tpk_path}

%ifarch %{arm}
install packaging/arm/%{internal_name}-%{version}.tpk %{buildroot}/%{preload_tpk_path}/
%else
install packaging/arm64/%{internal_name}-%{version}.tpk %{buildroot}/%{preload_tpk_path}/
%endif


%files
%defattr(-,root,root,-)
%{preload_tpk_path}/*
%license LICENSE