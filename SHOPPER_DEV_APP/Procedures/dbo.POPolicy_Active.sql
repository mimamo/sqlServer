USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POPolicy_Active]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POPolicy_Active    Script Date: 12/17/97 10:48:35 AM ******/
Create Procedure [dbo].[POPolicy_Active] @Parm1 Varchar(10) as
Select * from POPolicy where PolicyID like @Parm1
And Status = 'A'
Order by PolicyID
GO
