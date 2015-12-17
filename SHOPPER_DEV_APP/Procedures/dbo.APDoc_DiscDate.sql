USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_DiscDate]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_DiscDate    Script Date: 4/7/98 12:49:19 PM ******/
Create Proc [dbo].[APDoc_DiscDate] @parm1 smalldatetime, @parm2 smalldatetime as
Select * from APDoc where discdate between @parm1 and @parm2
Order by cpnyid, acct, sub, Refnbr
GO
