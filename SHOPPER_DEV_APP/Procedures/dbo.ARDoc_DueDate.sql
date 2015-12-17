USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_DueDate]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_DueDate    Script Date: 4/7/98 12:49:19 PM ******/
Create Proc [dbo].[ARDoc_DueDate] @parm1 smalldatetime, @parm2 smalldatetime as
Select * from ARDoc where duedate between @parm1
 and @parm2
Order by CpnyID, BankAcct, Banksub, Refnbr
GO
