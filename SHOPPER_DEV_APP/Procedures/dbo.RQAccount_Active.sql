USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[RQAccount_Active]    Script Date: 12/16/2015 15:55:31 ******/
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
