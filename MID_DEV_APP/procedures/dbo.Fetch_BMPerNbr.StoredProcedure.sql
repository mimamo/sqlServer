USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Fetch_BMPerNbr]    Script Date: 12/21/2015 14:17:44 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Fetch_BMPerNbr] as
Select PerNbr from BMSetup (NOLOCK)
GO
