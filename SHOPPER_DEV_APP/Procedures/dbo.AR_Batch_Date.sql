USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AR_Batch_Date]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AR_Batch_Date    Script Date: 4/7/98 12:49:19 PM ******/
create Proc [dbo].[AR_Batch_Date] @parm1 smalldatetime as
  Select * from batch
  Where module = 'AR' and battype <> 'C' and dateent = @parm1
  Order by Batnbr
GO
