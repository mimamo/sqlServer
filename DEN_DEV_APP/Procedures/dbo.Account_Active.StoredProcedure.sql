USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Account_Active]    Script Date: 12/21/2015 14:05:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Account_Active    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc [dbo].[Account_Active] @parm1 varchar ( 10) as
    Select * from Account where Acct like @parm1 and Active <> 0 Order by Acct
GO
