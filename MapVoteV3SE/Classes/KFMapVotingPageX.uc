//-----------------------------------------------------------
// KFMapVotingPageX - Modification by Marco
//-----------------------------------------------------------
class KFMapVotingPageX extends ROMapVotingPage;

var automated moEditBox SearchEdit;
var localized string strHelp;

function InternalOnOpen()
{
	super.InternalOnOpen();

	if (!bHasFocus) {
		lb_MapListBox.SetVisibility(false);
		lb_VoteCountListBox.SetVisibility(false);
		return;
	}

	lb_MapListBox.SetVisibility(true);
	lb_VoteCountListBox.SetVisibility(true);


	if (f_Chat.ed_Chat.GetText() != "") {
		f_Chat.ed_Chat.SetFocus(none);
		SetFocus(f_Chat.ed_Chat);
		// move the cursor to the end of the text
		f_Chat.ed_Chat.MyEditBox.CaretPos = len(f_Chat.ed_Chat.GetText());
		f_Chat.ed_Chat.MyEditBox.bAllSelected = false;
	}
	else {
		Controller.PlayInterfaceSound(CS_Edit);
		SearchEdit.SetFocus(none);
	}
	f_Chat.ReceiveChat(strHelp);
}

// Also allow admins force mapswitch.
final function SendAdminSwitch(GUIComponent Sender)
{
	local int MapIndex,GameConfigIndex;

	if( Sender == lb_VoteCountListBox.List )
	{
		MapIndex = MapVoteCountMultiColumnList(lb_VoteCountListBox.List).GetSelectedMapIndex();
		if( MapIndex>=0 )
			GameConfigIndex = MapVoteCountMultiColumnList(lb_VoteCountListBox.List).GetSelectedGameConfigIndex();
	}
	else
	{
		MapIndex = MapVoteMultiColumnList(lb_MapListBox.List).GetSelectedMapIndex();
		if( MapIndex>=0 )
			GameConfigIndex = int(co_GameType.GetExtra());
	}
	if( MapIndex>=0 )
		MVRI.SendMapVote(MapIndex,-(GameConfigIndex+1)); // Send with negative game index to indicate admin switch.
}

// Allow admins vote like all other players.
function SendVote(GUIComponent Sender)
{
	local int MapIndex,GameConfigIndex;

	if( Sender == lb_VoteCountListBox.List )
	{
		MapIndex = MapVoteCountMultiColumnList(lb_VoteCountListBox.List).GetSelectedMapIndex();
		if( MapIndex>=0 )
			GameConfigIndex = MapVoteCountMultiColumnList(lb_VoteCountListBox.List).GetSelectedGameConfigIndex();
	}
	else
	{
		MapIndex = MapVoteMultiColumnList(lb_MapListBox.List).GetSelectedMapIndex();
		if( MapIndex>=0 )
			GameConfigIndex = int(co_GameType.GetExtra());
	}
	if( MapIndex>=0 )
	{
		if( MVRI.MapList[MapIndex].bEnabled )
			MVRI.SendMapVote(MapIndex,GameConfigIndex);
		else PlayerOwner().ClientMessage(lmsgMapDisabled);
	}
}

function GameTypeChanged(GUIComponent Sender)
{
	super.GameTypeChanged(Sender);
	SearchEdit.SetText("");
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
	local Interactions.EInputKey iKey;
	if (State != 3)
		return false;

	iKey = EInputKey(Key);
	if (iKey >= IK_F1 && iKey < IK_F12) {
		// F keys
		switch (iKey) {
			case IK_F1:
				Controller.PlayInterfaceSound(CS_Edit);
				f_Chat.ReceiveChat(strHelp);
				return true;
			case IK_F2:
				Controller.PlayInterfaceSound(CS_Edit);
				f_Chat.ed_Chat.SetFocus(none);
				SetFocus(f_Chat.ed_Chat);
				return true;
			case IK_F3:
				Controller.PlayInterfaceSound(CS_Edit);
				SearchEdit.SetFocus(none);
				SetFocus(SearchEdit);
				return true;
			case IK_F4:
				Controller.PlayInterfaceSound(CS_Edit);
				co_GameType.SetFocus(none);
				SetFocus(co_GameType);
				co_GameType.MyComboBox.ShowListBox(co_GameType.MyComboBox);
				return true;
		}
	}
	return false;
}

function bool OnGameTypeKey(out byte Key, out byte State, float delta)
{
	local Interactions.EInputKey iKey;

	if (State != 3)
		return false;

	iKey = EInputKey(Key);
	if (iKey == IK_Enter) {
		Controller.PlayInterfaceSound(CS_Edit);
		co_GameType.MyComboBox.ShowListBox(co_GameType.MyComboBox);
		if (!co_GameType.MyComboBox.MyListBox.bVisible) {
			SearchEdit.SetFocus(none);
			SetFocus(SearchEdit);
		}
		return true;
	}
	return false;
}


function bool OnSearchKey(out byte Key, out byte st, float delta)
{
	// PlayerOwner().ClientMessage("OnSearchKeyType Key="$Key @ "State="$State);
	if (st != 3)
		return false;  // not a key press

	// redirect Fn keys to BuyMenuTab
	if (Key >= 0x70 && Key < 0x7C) {
		return InternalOnKeyEvent(Key, st, delta);
	}

	switch (Key) {
		case 0x08: // IK_Backspace
			if (Controller.CtrlPressed) {
				SearchEdit.SetText("");
				Key = 0;
				st = 0;
				return true;
			}
			break;
		case 0x0D: // IK_Enter
			SendVote(lb_MapListBox.List);
			return true;
		case 0x26: // IK_Up
			lb_MapListBox.List.Up();
			return true;
		case 0x28: // IK_Down
			lb_MapListBox.List.Down();
			return true;
	}
	return SearchEdit.MyEditBox.InternalOnKeyEvent(Key, st, delta);
}

function bool OnSearchKeyType(out byte Key, optional string Unicode)
{
    // PlayerOwner().ClientMessage("OnSearchKeyType Key="$Key @ "Unicode="$Unicode);
    if (Key == 127) {
        return true;  // control characters
    }
    if (Unicode == "`" || Unicode == "~") {
        // ignore console key input
        return true;
    }
    return SearchEdit.MyEditBox.InternalOnKeyType(Key, Unicode);
}

function OnSearchChange(GUIComponent Sender)
{
    local string s;

    s = SearchEdit.GetText();
	MVMultiColumnList(lb_MapListBox.List).ApplyFilter(s);
}

function bool AlignBK(Canvas C)
{

	if (lb_VoteCountListbox.MyList != none) {
		i_MapCountListBackground.WinWidth  = lb_VoteCountListbox.MyList.ActualWidth();
		i_MapCountListBackground.WinHeight = lb_VoteCountListbox.MyList.ActualHeight();
		i_MapCountListBackground.WinLeft   = lb_VoteCountListbox.MyList.ActualLeft();
		i_MapCountListBackground.WinTop    = lb_VoteCountListbox.MyList.ActualTop();
	}

	if (lb_MapListBox.MyList != none) {
		i_MapListBackground.WinWidth  	= lb_MapListBox.MyList.ActualWidth();
		i_MapListBackground.WinHeight 	= lb_MapListBox.MyList.ActualHeight();
		i_MapListBackground.WinLeft  	= lb_MapListBox.MyList.ActualLeft();
		i_MapListBackground.WinTop	 	= lb_MapListBox.MyList.ActualTop();
	}

	return false;
}


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: moEditBox'KFMapVotingPageX.SearchEditbox'
    begin object name=SearchEditbox class=Class'XInterface.moEditBox'
        CaptionWidth=0.3500000
        Caption="F3 Map Search:"
        OnCreateComponent=SearchEditbox.InternalOnCreateComponent
        WinTop=0.3150000
        WinLeft=0.2000000
        WinWidth=0.6000000
        WinHeight=0.0375000
        TabOrder=2
        bBoundToParent=true
        bScaleToParent=true
        OnChange=KFMapVotingPageX.OnSearchChange
        OnKeyType=KFMapVotingPageX.OnSearchKeyType
        OnKeyEvent=KFMapVotingPageX.OnSearchKey
    end object
    SearchEdit=SearchEditbox
    strHelp=". TeamSay|/ Console command|+ Like the current map|- Dislike the current map| "
    // Reference: MVMultiColumnListBox'KFMapVotingPageX.MapListBox'
    begin object name=MapListBox class=Class'MVMultiColumnListBox'
        HeaderColumnPerc=/* Array type was not detected. */
        bVisibleWhenEmpty=true
        OnCreateComponent=MapListBox.InternalOnCreateComponent
        StyleName="ServerBrowserGrid"
        WinTop=0.3700000
        WinLeft=0.0200000
        WinWidth=0.9600000
        WinHeight=0.3300000
        TabOrder=3
        bBoundToParent=true
        bScaleToParent=true
        OnRightClick=MapListBox.InternalOnRightClick
    end object
    lb_MapListBox=MapListBox
    // Reference: MVCountColumnListBox'KFMapVotingPageX.VoteCountListBox'
    begin object name=VoteCountListBox class=Class'MVCountColumnListBox'
        HeaderColumnPerc=/* Array type was not detected. */
        bVisibleWhenEmpty=true
        OnCreateComponent=VoteCountListBox.InternalOnCreateComponent
        WinTop=0.0500000
        WinLeft=0.0200000
        WinWidth=0.9600000
        WinHeight=0.2200000
        TabOrder=0
        bBoundToParent=true
        bScaleToParent=true
        OnRightClick=VoteCountListBox.InternalOnRightClick
    end object
    lb_VoteCountListBox=VoteCountListBox
    // Reference: moComboBox'KFMapVotingPageX.GameTypeCombo'
    begin object name=GameTypeCombo class=Class'XInterface.moComboBox'
        bReadOnly=true
        CaptionWidth=0.3500000
        Caption="F4 Select Game Type:"
        OnCreateComponent=GameTypeCombo.InternalOnCreateComponent
        WinTop=0.2750000
        WinLeft=0.2000000
        WinWidth=0.6000000
        WinHeight=0.0375000
        TabOrder=1
        bBoundToParent=true
        bScaleToParent=true
        OnKeyEvent=KFMapVotingPageX.OnGameTypeKey
    end object
    co_GameType=GameTypeCombo
    // Reference: GUIImage'KFMapVotingPageX.MapListBackground'
    begin object name=MapListBackground class=Class'XInterface.GUIImage'
        Image=Texture'KF_InterfaceArt_tex.Menu.Thin_border_SlightTransparent'
        ImageStyle=1
        OnDraw=KFMapVotingPageX.AlignBK
    end object
    i_MapListBackground=MapListBackground
    // Reference: KFMapVoteFooterX'KFMapVotingPageX.ChatFooter'
    begin object name=ChatFooter class=Class'KFMapVoteFooterX'
        WinTop=0.7050000
        WinLeft=0.0200000
        WinWidth=0.9600000
        WinHeight=0.2750000
        TabOrder=10
    end object
    f_Chat=ChatFooter
    OnKeyEvent=KFMapVotingPageX.InternalOnKeyEvent
}