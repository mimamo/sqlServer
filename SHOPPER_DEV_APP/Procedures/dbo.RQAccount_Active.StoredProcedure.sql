USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQAccount_Active]    Script Date: 12/21/2015 14:34:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.RQAccount_Active    Script Date: 12/17/97 10:48:21 AM ******/
Create Procedure [dbo].[RQAccount_Active] @Parm1 Varchar(10) as
Select * From Account Where Acct like @parm1 and
Active = 1
Order by Acct
GO
