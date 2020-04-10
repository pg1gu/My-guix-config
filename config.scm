;; This is an operating system configuration template
;; for a "desktop" setup with GNOME and Xfce where the
;; root partition is encrypted with LUKS.

(use-modules (gnu) (gnu system nss)); (gnu packages make) (gnu packages gnuzilla) (gnu packages web-browsers))
(use-service-modules desktop xorg)
(use-package-modules certs emacs web-browsers gnuzilla lisp wm xorg emacs-xyz version-control)

(operating-system
  (host-name "Eguix")
  (timezone "US/Mountain")
  (locale "en_US.utf8")

  ;; Choose US English keyboard layout.  The "altgr-intl"
  ;; variant provides dead keys for accented characters.
  (keyboard-layout (keyboard-layout "us" "altgr-intl"))

  ;; Use the UEFI variant of GRUB with the EFI System
  ;; Partition mounted on /boot/efi.
  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (target "/dev/sda")
                (keyboard-layout keyboard-layout)))

  (file-systems (append
                 (list (file-system
                         (device (file-system-label "Eguix"))
                         (mount-point "/")
                         (type "btrfs")))
                 %base-file-systems))

  (users (append (list (user-account
			(name "pg1gu")
			(comment "Ethan")
			(group "users")
			(supplementary-groups '("wheel" "netdev"
						"audio" "video")))
		       (user-account
			(name "p1njp")
			(comment "Also Ethan")
			(group "users")
			(supplementary-groups '("wheel" "netdev"
						"audio" "video"))))
		 %base-user-accounts))

  ;; This is where we specify system-wide packages.
  (packages (append (list
                     ;; for HTTPS access
                     nss-certs
                     ;; for user mounts
                     emacs emacs-slime icecat qutebrowser clisp emacs-exwm git emacs-paredit)
                    %base-packages))

  (services (append (list (service mate-desktop-service-type)
			  (service xfce-desktop-service-type)
			  (service gnome-desktop-service-type)
			  (set-xorg-configuration
                           (xorg-configuration
                            (keyboard-layout keyboard-layout))))
                    %desktop-services))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
