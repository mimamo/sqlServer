USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TransDef_All]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.TransDef_All    Script Date: 4/7/98 12:45:04 PM ******/
Create Proc [dbo].[TransDef_All] @parm1 varchar ( 10) AS
     Select * from FSDefHdr
          Where TrslId like @parm1
          Order by TrslId
GO
