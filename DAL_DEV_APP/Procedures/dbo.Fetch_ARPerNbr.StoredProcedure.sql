USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Fetch_ARPerNbr]    Script Date: 12/21/2015 13:35:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Fetch_ARPerNbr    Script Date: 02/14/01 12:15:04 PM ******/
Create Proc  [dbo].[Fetch_ARPerNbr] as
Select PerNbr from ARSetup (NOLOCK)
GO
