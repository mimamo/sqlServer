USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ADG_ProcessMgr_QueueUpdSh]    Script Date: 12/16/2015 15:55:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[ADG_ProcessMgr_QueueUpdSh]
	@CpnyID		varchar(10),
	@ShipperID	varchar(15)
as
	declare	@DelayMins		smallint
	declare	@ProcessPriority	smallint
	declare	@ProcessType		varchar(5)

	select	@DelayMins = (select DelayShipperUpdate from SOSetup)
	select	@DelayMins = coalesce(@DelayMins, 0)

	select	@ProcessPriority	= 110
	select	@ProcessType		= 'UPDSH'

	set nocount on

	insert ProcessQueue
	(
	CpnyID, CreateShipper, Crtd_DateTime, Crtd_Prog, Crtd_User,
	CustID,InvtID, LUpd_DateTime, LUpd_Prog, LUpd_User,
	MaintMode, NoteID, POLineRef, PONbr, ProcessAt,
	ProcessPriority, ProcessType,
	S4Future01, S4Future02, S4Future03, S4Future04, S4Future05,
	S4Future06, S4Future07, S4Future08, S4Future09, S4Future10,
	S4Future11, S4Future12, SiteID, SOLineRef, SOOrdNbr,
	SOSchedRef, SOShipperID, SOShipperLineRef, User1, User10,
	User2, User3, User4, User5, User6,
	User7, User8, User9
	)

	values
	(
	@CpnyID, 0, getdate(), 'SQL', 'SQL',
	'', '', getdate(), 'SQL', 'SQL',
	0, 0, '', '', DateAdd(mi, @DelayMins, getdate()),
	@ProcessPriority, @ProcessType,
	'', '', 0, 0, 0,
	0,'', '', 0, 0,
	'', '',	'', '', '',
	'', @ShipperID, '', '', '',
	'', '', '', 0, 0,
	'', '', ''
	)
GO
