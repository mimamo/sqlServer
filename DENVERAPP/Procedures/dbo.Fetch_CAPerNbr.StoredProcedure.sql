USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Fetch_CAPerNbr]    Script Date: 12/21/2015 15:42:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Fetch_CAPerNbr    Script Date: 02/14/01 12:15:04 PM ******/
Create Proc  [dbo].[Fetch_CAPerNbr] as
Select PerNbr from CASetup (NOLOCK)
GO
