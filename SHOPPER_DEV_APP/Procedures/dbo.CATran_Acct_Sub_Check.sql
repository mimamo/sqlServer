USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CATran_Acct_Sub_Check]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CATran_Acct_Sub_Check    Script Date: 4/7/98 12:49:20 PM ******/
Create Proc [dbo].[CATran_Acct_Sub_Check] @parm1 varchar ( 10), @parm2 varchar(10),  @parm3 varchar ( 24), @parm4 varchar ( 10) as
  Select * from CATran
  Where CpnyID like @parm1 and BankAcct like @parm2 and Banksub like @parm3
  and Refnbr like @parm4
Order by CpnyID, BankAcct, BankSub, RefNbr
GO
