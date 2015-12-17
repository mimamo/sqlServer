USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemSite_ABC_Freq]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ItemSite_ABC_Freq    Script Date: 4/17/98 10:58:17 AM ******/
Create Proc [dbo].[ItemSite_ABC_Freq] @parm1 varchar(10) as
    select * from ItemSite
	where abccode <> '' and siteid = @parm1
	and countstatus = 'A' order by abccode, invtid
GO
