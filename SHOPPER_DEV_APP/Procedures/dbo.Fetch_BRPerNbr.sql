USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Fetch_BRPerNbr]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Fetch_BRPerNbr] as
Select PerNbr from BRSetup (NOLOCK)
GO
