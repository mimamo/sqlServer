USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Fetch_APPerNbr]    Script Date: 12/21/2015 15:49:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Fetch_APPerNbr    Script Date: 02/14/01 12:15:04 PM ******/
Create Proc  [dbo].[Fetch_APPerNbr] as
Select PerNbr from APSetup (NOLOCK)
GO
