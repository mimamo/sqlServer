USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Account_Descr]    Script Date: 12/16/2015 15:55:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Account_Descr    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Account_Descr] @parm1 varchar ( 10) as
    Select Descr from Account where Acct = @parm1 order by Acct
GO
