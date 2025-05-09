// Created by Marco
class MVLikePage extends LargeWindow;

var automated GUILabel l_Text;
var automated GUIButton b_Like,b_Dislike;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);
	b_Like.Caption = MakeColorCode(Class'Canvas'.Static.MakeColor(64,255,64))$b_Like.Caption;
	b_Dislike.Caption = MakeColorCode(Class'Canvas'.Static.MakeColor(255,64,64))$b_Dislike.Caption;
}

function bool LikeClick(GUIComponent Sender)
{
	KFVotingReplicationInfo(PlayerOwner().VoteReplicationInfo).SetMapLike(Sender==b_Like);
	Controller.CloseMenu();
	return false;
}


// Decompiled with UE Explorer.
defaultproperties
{
    // Reference: GUILabel'MVLikePage.LikeInfo'
    begin object name=LikeInfo class=Class'XInterface.GUILabel'
        Caption="Did you like this map?"
        TextAlign=1
        TextColor=(R=255,G=255,B=64,A=255)
        WinTop=0.2000000
        WinLeft=0.1000000
        WinWidth=0.8000000
        WinHeight=0.4000000
    end object
    l_Text=LikeInfo
    // Reference: GUIButton'MVLikePage.LikeButton'
    begin object name=LikeButton class=Class'XInterface.GUIButton'
        Caption="Like"
        WinTop=0.5300000
        WinLeft=0.3800000
        WinWidth=0.1100000
        WinHeight=0.0750000
        OnClick=MVLikePage.LikeClick
        OnKeyEvent=LikeButton.InternalOnKeyEvent
    end object
    b_Like=LikeButton
    // Reference: GUIButton'MVLikePage.DislikeButton'
    begin object name=DislikeButton class=Class'XInterface.GUIButton'
        Caption="Dislike"
        WinTop=0.5300000
        WinLeft=0.5100000
        WinWidth=0.1100000
        WinHeight=0.0750000
        OnClick=MVLikePage.LikeClick
        OnKeyEvent=DislikeButton.InternalOnKeyEvent
    end object
    b_Dislike=DislikeButton
    WindowName="Map review"
    bRequire640x480=false
    WinTop=0.3500000
    WinLeft=0.3000000
    WinWidth=0.4000000
    WinHeight=0.3000000
    bAcceptsInput=false
}