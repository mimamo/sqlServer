USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AllModule_PerNbrs]    Script Date: 12/21/2015 14:34:07 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AllModule_PerNbrs    Script Date: 4/17/98 12:50:25 PM ******/
/****** Object:  Stored Procedure dbo.AllModule_PerNbrs    Script Date: 4/7/98 12:56:04 PM ******/
Create Proc  [dbo].[AllModule_PerNbrs] as
EXEC Fetch_GLPerNbr
EXEC Fetch_PRPerNbr
EXEC Fetch_APPerNbr
EXEC Fetch_PCPerNbr
EXEC Fetch_ARPerNbr
EXEC Fetch_INPerNbr
EXEC Fetch_CAPerNbr
GO
