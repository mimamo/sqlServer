USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Loctable_PILastCountDate]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Loctable_PILastCountDate    Script Date: 4/17/98 10:58:18 AM ******/
Create Proc [dbo].[Loctable_PILastCountDate] @parm1 varchar(10), @parm2 smalldatetime as
  select * from LocTable
	where siteid = @Parm1 and countstatus = 'A' and lastcountdate <= @Parm2
	order by  whseloc
GO
