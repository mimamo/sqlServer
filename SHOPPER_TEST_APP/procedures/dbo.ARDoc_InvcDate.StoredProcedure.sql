USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARDoc_InvcDate]    Script Date: 12/21/2015 16:06:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARDoc_InvcDate    Script Date: 4/7/98 12:49:19 PM ******/
Create Proc [dbo].[ARDoc_InvcDate] @parm1 smalldatetime, @parm2 smalldatetime as
Select * from ARDoc where Docdate between @parm1 and @parm2
Order by CpnyID, BankAcct, Banksub, Refnbr
GO
