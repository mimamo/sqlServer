USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[WrkComponent_DEL_All]    Script Date: 12/21/2015 16:13:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.WrkComponent_DEL_All    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.WrkComponent_DEL_All    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc  [dbo].[WrkComponent_DEL_All] as
       Delete from WrkComponent
GO
