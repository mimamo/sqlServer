USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Fetch_WOPerNbr]    Script Date: 12/21/2015 16:13:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Fetch_WOPerNbr] as
Select PerNbr from WOSetup (NOLOCK)
GO
