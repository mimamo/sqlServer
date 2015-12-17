USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DMG_WOSetup_Selected]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[DMG_WOSetup_Selected]
AS
	select	Mfg_Task,
		WOPendingProject,
		S4Future12			-- Print WO Batch Reports

	from	WOSetUp

-- Copyright 1998, 1999 by Solomon Software, Inc. All rights reserved.
GO
