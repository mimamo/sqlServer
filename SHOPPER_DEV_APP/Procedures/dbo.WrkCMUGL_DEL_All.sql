USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkCMUGL_DEL_All]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.WrkCMUGL_DEL_All    Script Date: 4/7/98 12:43:41 PM ******/
Create Proc  [dbo].[WrkCMUGL_DEL_All] as
       Delete from WrkCMUGL
GO
