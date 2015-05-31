; Script generated by the HM NIS Edit Script Wizard.

!include "LogicLib.nsh"

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "serialosc"
!define PRODUCT_VERSION "1.4"
!define PRODUCT_PUBLISHER "monome"
!define PRODUCT_WEB_SITE "http://monome.org/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\serialoscd.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

!define FILE_SRC "C:\Users\wrl\Desktop\serialosc"
!define SVC_NAME "serialosc"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "mlogo.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\win-uninstall.ico"

!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Start serialosc service"
!define MUI_FINISHPAGE_RUN_FUNCTION start_service

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "license.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME}"
OutFile "${PRODUCT_NAME}-${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES\Monome\serialosc"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show
BrandingText " "

Section "serialosc" SEC01
  SimpleSC::StopService ${SVC_NAME} 1 30

  SetOutPath "$INSTDIR"
  SetOverwrite try
  File "${FILE_SRC}\libmonome.dll"
  File "${FILE_SRC}\liblo-7.dll"
  File "${FILE_SRC}\serialoscd.exe"
  File "${FILE_SRC}\serialosc-detector.exe"
  File "${FILE_SRC}\serialosc-device.exe"
  SetOutPath "$INSTDIR\monome"
  File "${FILE_SRC}\monome\protocol_40h.dll"
  File "${FILE_SRC}\monome\protocol_mext.dll"
  File "${FILE_SRC}\monome\protocol_series.dll"

  ; remove old serialosc executable
  Delete "$INSTDIR\serialosc.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninstall.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\serialoscd.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\serialoscd.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"

  SimpleSC::InstallService ${SVC_NAME} ${SVC_NAME} "16" "2" "$INSTDIR\serialoscd.exe" "" "" ""
  SimpleSC::SetServiceBinaryPath ${SVC_NAME} "$INSTDIR\serialoscd.exe"
  SimpleSC::SetServiceDescription ${SVC_NAME} "OSC server for Monomes"
  SimpleSC::SetServiceDelayedAutoStartInfo ${SVC_NAME} "1"
SectionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Function start_service
  SimpleSC::StartService ${SVC_NAME}
FunctionEnd

Section Uninstall
  SimpleSC::StopService ${SVC_NAME} 1 30
  SimpleSC::RemoveService ${SVC_NAME}

  Delete "$INSTDIR\uninstall.exe"
  Delete "$INSTDIR\libmonome.dll"
  Delete "$INSTDIR\liblo-7.dll"
  Delete "$INSTDIR\serialoscd.exe"
  Delete "$INSTDIR\serialosc-detector.exe"
  Delete "$INSTDIR\serialosc-device.exe"
  Delete "$INSTDIR\monome\protocol_series.dll"
  Delete "$INSTDIR\monome\protocol_mext.dll"
  Delete "$INSTDIR\monome\protocol_40h.dll"

  RMDir "$INSTDIR\monome"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd
