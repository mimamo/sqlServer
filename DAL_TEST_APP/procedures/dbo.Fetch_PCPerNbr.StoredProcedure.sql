USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Fetch_PCPerNbr]    Script Date: 12/21/2015 13:57:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Fetch_PCPerNbr    Script Date: 02/14/01 12:15:04 PM ******/
Create Proc  [dbo].[Fetch_PCPerNbr] as
Select PerNbr from PCSetup (NOLOCK)
GO
