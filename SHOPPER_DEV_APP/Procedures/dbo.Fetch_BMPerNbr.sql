USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Fetch_BMPerNbr]    Script Date: 12/16/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Fetch_BMPerNbr] as
Select PerNbr from BMSetup (NOLOCK)
GO
