USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[Fetch_BRPerNbr]    Script Date: 12/21/2015 15:42:54 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Fetch_BRPerNbr] as
Select PerNbr from BRSetup (NOLOCK)
GO
