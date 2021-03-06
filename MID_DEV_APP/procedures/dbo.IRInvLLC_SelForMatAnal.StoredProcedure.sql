USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[IRInvLLC_SelForMatAnal]    Script Date: 12/21/2015 14:17:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE procedure [dbo].[IRInvLLC_SelForMatAnal] AS
if not exists (select * from sysobjects where id = object_id(N'[dbo].[IRCEPRestrict]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	Select * from IRInvLLC order by LowLevelCode
Else
	If (select count(*) from IRCepRestrict) > 0
		Select * from IRInvLLC where exists (Select * from IRCepRestrict where IRCepRestrict.InvtId = IRInvLLC.InvtId) order by LowLevelCode
	Else
		Select * from IRInvLLC order by LowLevelCode
GO
