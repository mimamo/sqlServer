USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Fetch_PRPerNbr]    Script Date: 12/21/2015 14:06:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Fetch_PRPerNbr    Script Date: 02/14/01 12:15:04 PM ******/
Create Proc  [dbo].[Fetch_PRPerNbr] as
Select PerNbr from PRSetup (NOLOCK)
GO
