USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Subacct_Count]    Script Date: 12/21/2015 14:06:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Subacct_Count    Script Date: 4/7/98 12:38:59 PM ******/
Create Proc  [dbo].[Subacct_Count] as
       Select count(*) from Subacct
GO
