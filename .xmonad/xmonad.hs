import XMonad
-- LAYOUTS
import XMonad.Layout.Spacing
import XMonad.Layout.Fullscreen 
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Tabbed
import XMonad.Layout.ResizableTile
import XMonad.Layout.Circle
-- WINDOW RULES
import XMonad.ManageHook
-- KEYBOARD & MOUSE CONFIG
import XMonad.Util.EZConfig
import XMonad.Actions.FloatKeys
import Graphics.X11.ExtraTypes.XF86
-- STATUS BAR
import XMonad.Hooks.DynamicLog hiding (xmobar, xmobarPP, xmobarColor, sjanssenPP, byorgeyPP)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Util.Dmenu
--import XMonad.Hooks.FadeInactive
import XMonad.Hooks.EwmhDesktops hiding (fullscreenEventHook)
import System.IO (hPutStrLn)
--import XMonad.Operations
import qualified XMonad.StackSet as W
import qualified XMonad.Actions.FlexibleResize as FlexibleResize
import XMonad.Util.Run (spawnPipe)
import XMonad.Actions.CycleWS			-- nextWS, prevWS
import XMonad.Actions.Warp
import Data.List			-- clickable workspaces

--------------------------------------------------------------------------------------------------------------------
-- DECLARE WORKSPACES RULES
--------------------------------------------------------------------------------------------------------------------
--myLayout = onWorkspace (myWorkspaces !! 0) (avoidStruts (tiledSpace ||| tiled) ||| fullTile)
--		$ onWorkspace (myWorkspaces !! 1) (avoidStruts (tiledSpace ||| fullTile) ||| fullScreen)
--		$ onWorkspace (myWorkspaces !! 2) (avoidStruts (simplestFloat))
--		$ avoidStruts ( tiledSpace  ||| tiled ||| fullTile ) 
myLayout = avoidStruts (tiled ||| tiledSpace ||| fullTile)
	where
		tiled  		= spacing 5 $ ResizableTall nmaster delta ratio [] 
		tiledSpace  	= spacing 60 $ ResizableTall nmaster delta ratio [] 
		fullScreen 	= noBorders(fullscreenFull Full)
		fullTile 	= ResizableTall nmaster delta ratio [] 
		borderlessTile	= noBorders(fullTile)
		-- Default number of windows in master pane
		nmaster = 1
		-- Percent of the screen to increment when resizing
		delta 	= 5/100
		-- Default proportion of the screen taken up by main pane
		ratio 	= toRational (2/(1 + sqrt 5 :: Double)) 


--------------------------------------------------------------------------------------------------------------------
-- WORKSPACE DEFINITIONS
--------------------------------------------------------------------------------------------------------------------
myWorkspaces = clickable $ ["I","II","III","IV","V","VI"]
	where clickable l = [ "^ca(1,xdotool key alt+" ++ show (n) ++ ")" ++ ws ++ "^ca()" |
				(i,ws) <- zip [1..] l,
				let n = i ]

--------------------------------------------------------------------------------------------------------------------
-- APPLICATION SPECIFIC RULES
--------------------------------------------------------------------------------------------------------------------
myManageHook = composeAll 	[ resource =? "dmenu" --> doFloat
				, resource =? "dzen2"	--> doIgnore
				, stringProperty "WM_WINDOW_ROLE" =? "pop-up" --> doFloat
				, isFullscreen --> (doF W.focusDown <+> doFullFloat)
				, manageDocks]
newManageHook = myManageHook <+> manageHook defaultConfig 

--------------------------------------------------------------------------------------------------------------------
-- DZEN LOG RULES for workspace names, layout image, current program title
--------------------------------------------------------------------------------------------------------------------
myLogHook h = dynamicLogWithPP ( defaultPP
	{
		  ppCurrent		= dzenColor color9 background .	pad
		, ppVisible		= dzenColor color6 background . 	pad
		, ppHidden		= dzenColor color6 background . 	pad
		, ppHiddenNoWindows	= dzenColor color0 background .	pad
		, ppWsSep		= ""
		, ppSep			= "    "
		, ppLayout		= wrap "^ca(1,xdotool key alt+space)" "^ca()" . dzenColor foreground background .
				(\x -> case x of
					"Full"				->	"^i(/home/michael/.xmonad/dzen2/layout_full.xbm)"
					"Spacing 5 ResizableTall"	->	"^i(/home/michael/.xmonad/dzen2/layout_tall.xbm)"
					"ResizableTall"			->	"^i(/home/michael/.xmonad/dzen2/layout_tall.xbm)"
					"SimplestFloat"			->	"^i(/home/michael/.xmonad/dzen2/mouse_01.xbm)"
					"Circle"			->	"^i(/home/michael/.xmonad/dzen2/full.xbm)"
					_				->	"^i(/home/michael/.xmonad/dzen2/grid.xbm)"
				) 
		, ppTitle	=  wrap "^ca(1,xdotool key alt+shift+x)^fg(#D23D3D)^fn(fkp)x ^fn()" "^ca()" . dzenColor foreground background . shorten 40 . pad
		, ppOrder	=  \(ws:l:t:_) -> [ws,l, t]
		, ppOutput	=   hPutStrLn h
	} )


--------------------------------------------------------------------------------------------------------------------
-- Spawn pipes and menus on boot, set default settings
--------------------------------------------------------------------------------------------------------------------
myXmonadBar = "dzen2 -x '0' -y '0' -h '14' -w '500' -ta 'l' -fg '"++foreground++"' -bg '"++background++"' -fn "++myFont
myStatusBar = "conky -qc /home/michael/.xmonad/.conky_dzen | dzen2 -x '500' -w '1420' -h '14' -ta 'r' -bg '"++background++"' -fg '"++foreground++"' -y '0' -fn "++myFont

main = do
	dzenLeftBar 	<- spawnPipe myXmonadBar
	dzenRightBar	<- spawnPipe myStatusBar
	xmonad $ ewmh defaultConfig
		{ terminal		= myTerminal
		, borderWidth		= 3
		, normalBorderColor 	= background
		, focusedBorderColor  	= color9
		, modMask 		= mod1Mask
		, layoutHook 		= smartBorders $ myLayout
		, workspaces 		= myWorkspaces
		, manageHook		= newManageHook
		, handleEventHook 	= fullscreenEventHook <+> docksEventHook
		, startupHook		= setWMName "LG3D"
		, logHook		= myLogHook dzenLeftBar -- >> fadeInactiveLogHook 0xdddddddd
		}

--------------------------------------------------------------------------------------------------------------------
-- Keyboard options
--------------------------------------------------------------------------------------------------------------------
		`additionalKeys`
		--[((mod4Mask			, xK_b), spawn "google-chrome")
		[((mod4Mask			, xK_b), spawn "chromium")
		,((mod4Mask			, xK_t), spawn "urxvtc")
		,((mod4Mask 			, xK_r), spawn "dmenu_run")
		,((mod1Mask			, xK_q), spawn "killall dzen2; killall conky; killall tint2; cd ~/.xmonad; ghc -threaded xmonad.hs; mv xmonad xmonad-x86_64-linux; xmonad --restart" )
		,((mod1Mask .|. shiftMask	, xK_x), kill)
		,((mod1Mask .|. shiftMask	, xK_c), return())
		,((mod1Mask  			, xK_p), moveTo Prev NonEmptyWS)
		,((mod1Mask  			, xK_n), moveTo Next NonEmptyWS)
		,((mod1Mask  			, xK_c), moveTo Next EmptyWS)
		,((mod4Mask  			, xK_l), spawn "slock") 
		,((mod1Mask .|. shiftMask	, xK_l), sendMessage MirrorShrink)
		,((mod1Mask .|. shiftMask	, xK_h), sendMessage MirrorExpand)
		,((mod1Mask  			, xK_a), withFocused (keysMoveWindow (-20,0)))
		,((mod1Mask  			, xK_f), withFocused (keysMoveWindow (20,0)))
		,((mod1Mask .|. shiftMask  	, xK_a), withFocused (keysResizeWindow (-20,0) (0,0)))
		,((mod1Mask .|. shiftMask  	, xK_d), withFocused (keysResizeWindow (0,-20) (0,0)))
		,((mod1Mask .|. shiftMask  	, xK_s), withFocused (keysResizeWindow (0,20) (0,0)))
		,((mod1Mask .|. shiftMask  	, xK_f), withFocused (keysResizeWindow (20,0) (0,0)))
		,((mod1Mask			, xK_0), spawn "xdotool key alt+6")
		,((mod1Mask			, xK_9), spawn "xdotool key alt+5")
		,((mod1Mask			, xK_8), spawn "xdotool key alt+4")
		,((0				, xK_Super_L), spawn "menu ~/.xmonad/apps")
		,((mod1Mask			, xK_Super_L), spawn "menu ~/.xmonad/configs")
		,((mod1Mask  			, xK_F1), spawn "~/.xmonad/sc ~/.xmonad/scripts/dzen_music.sh")
		,((mod1Mask  			, xK_F2), spawn "~/.xmonad/sc ~/.xmonad/scripts/dzen_date.sh")
		,((mod1Mask  			, xK_F3), spawn "~/.xmonad/sc ~/.xmonad/scripts/dzen_network.sh")
		,((mod1Mask  			, xK_F4), spawn "~/.xmonad/sc ~/.xmonad/scripts/dzen_vol.sh")
		,((mod1Mask  			, xK_F5), spawn "~/.xmonad/sc ~/.xmonad/scripts/dzen_battery.sh")
		,((mod1Mask  			, xK_F6), spawn "~/.xmonad/sc ~/.xmonad/scripts/dzen_hardware.sh")
		,((mod1Mask  			, xK_F7), spawn "~/.xmonad/sc ~/.xmonad/scripts/dzen_log.sh")
		]


-- Define constants

myTerminal 	= "urxvtc"
myBitmapsDir	= "~/.xmonad/dzen2/"

--myFont		= "-*-limey-*-*-*-*-*-*-*-*-*-*-*-*"
myFont		= "xft:SourceCodePro-Light:size=9"

background= "#181512"
foreground= "#bea492"

color0= "#332d29"
color8= "#817267"

color1= "#8c644c"
color9= "#9f7155"

color2= "#c4be90"
color10= "#bec17e"

color3= "#bfba92"
color11= "#fafac0"

color4= "#646a6d"
color12= "#626e74"

color5= "#6d6871"
color13= "#756f7b"

color6= "#3b484a"
color14= "#444d4e"

color7= "#504339"
color15= "#9a875f"
