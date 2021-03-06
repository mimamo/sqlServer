USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Location_PI]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Location_PI    Script Date: 4/17/98 10:58:18 AM ******/
Create Proc [dbo].[Location_PI] @Parm1 VarChar(10) as
   Update Location set selected = 1, CountStatus = 'P'
	From Location,loctable,itemsite
	Where location.countstatus = 'A' and itemsite.countstatus = 'A'
	and location.invtid = itemsite.invtid and location.siteid = itemsite.siteid
	and location.whseloc = loctable.whseloc and location.siteid = loctable.siteid
	and loctable.siteid = @parm1 and loctable.selected = 1
GO
