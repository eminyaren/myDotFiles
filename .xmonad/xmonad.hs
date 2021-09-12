import XMonad

import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Ungrab
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce

import XMonad.Layout.ThreeColumns
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers

import System.IO



myStartup = do
     spawnOnce "lxsession &"
     spawnOnce "thunar --daemon &"
     spawnOnce "compton &"
     spawnOnce "nitrogen --set-scaled --random &"
     spawnOnce "nm-applet &"
     spawnOnce "volumeicon &"
     spawnOnce "xfce4-power-manager &"
     spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x000000  --height 20 &"


myLayout = (spacing 5 $ tiled) ||| Mirror tiled ||| Full ||| threeCol
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1
    ratio    = 1/2
    delta    = 3/100


myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "Vncviewer" --> doFloat
    , className =? "QjackCtl"  --> doFloat
    , className =? "Inkscape"  --> doShift "7"
    , className =? "Gimp"      --> doShift "8"
    , className =? "Brave-browser" --> doShift "2"
    , className =? "firefox" --> doShift "2"
    , isFullscreen -->  doFullFloat
    ]


myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = orange " • "
    , ppTitle           = white . shorten 50 
    , ppCurrent         = white . wrap "| " " |"
    , ppHidden          = orange . wrap "*" ""
    , ppHiddenNoWindows = green . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    }


green, lowWhite, orange, red, white, yellow :: String -> String
orange  = xmobarColor "#c87137" ""
green     = xmobarColor "#5aa02c" ""
white    = xmobarColor "#f8f8f2" ""
yellow   = xmobarColor "#f1fa8c" ""
red      = xmobarColor "#ff5555" ""
lowWhite = xmobarColor "#bbbbbb" ""



main :: IO ()
main = xmonad
     . ewmh
   =<< statusBar "xmobar" myXmobarPP toggleStrutsKey myConfig
  where
    toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
    toggleStrutsKey XConfig{ modMask = m } = (m, xK_v)

myConfig = def
    { modMask = mod4Mask
    , manageHook = myManageHook <+> manageDocks <+> manageHook defaultConfig
    , layoutHook = smartBorders . avoidStruts $ myLayout
    , startupHook = myStartup
    , terminal = "kitty"
    , borderWidth = 3
    , focusedBorderColor = "#5aa02c"
    , handleEventHook = handleEventHook def <+> fullscreenEventHook
    }
  `additionalKeysP`
    [ ("M-b", spawn "brave")
    , ("M-r", spawn "~/scripts/resolve")
    , ("M-S-C-p", spawn "poweroff")
    , ("M-t", spawn "thunar")
    
    ]
