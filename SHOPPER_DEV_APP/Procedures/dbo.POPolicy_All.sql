USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[POPolicy_All]    Script Date: 12/16/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.POPolicy_All    Script Date: 12/17/97 10:48:41 AM ******/
Create Procedure [dbo].[POPolicy_All] @Parm1 Varchar(10) as
Select * from POPolicy Where PolicyID like @Parm1
Order by PolicyId
GO
