USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Itemsite_MoveClass_Freq]    Script Date: 12/21/2015 14:17:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Itemsite_MoveClass_Freq    Script Date: 4/17/98 10:58:18 AM ******/
Create Proc [dbo].[Itemsite_MoveClass_Freq] @parm1 varchar(10) as
   Select * from ItemSite where MoveClass <> ''
	and siteid = @Parm1 and countstatus = 'A'
	order by moveclass, invtid
GO
