Name:       moe.smoothie.sailimgur
Summary:    Sailimgur is an Imgur app for Sailfish OS, powered by Qt and QML
Version:    0.11.1
Release:    1
Group:      Applications/Internet
License:    GPLv3
URL:        http://ruleoftech.com/lab/sailimgur
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   qt5-qtsvg-plugin-imageformat-svg
Requires:   qt5-plugin-imageformat-gif
Requires:   qt5-qtsvg
Requires:   qt5-qtmultimedia
BuildRequires:  pkgconfig(Qt5Svg)
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Multimedia)
BuildRequires:  desktop-file-utils

%description
Sailimgur is an imgur app for Sailfish OS with simple and easy-to-use UI.
It provides basic functionality like browsing, uploading, searching,
favoriting, voting, viewing your favorites and images.

%prep
%autosetup

%build
%qmake5
%make_build

%install
rm -rf %{buildroot}
%make_install

desktop-file-install --delete-original \
  --dir %{buildroot}%{_datadir}/applications \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%defattr(644,root,root,-)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
