USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[Fetch_WOPerNbr]    Script Date: 12/21/2015 16:01:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Fetch_WOPerNbr] as
Select PerNbr from WOSetup (NOLOCK)
GO
