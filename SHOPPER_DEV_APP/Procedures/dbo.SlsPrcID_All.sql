USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SlsPrcID_All]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SlsPrcID_All    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.SlsPrcID_All    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc [dbo].[SlsPrcID_All] @Parm1 VarChar(15) as
   Select * from Slsprc where SlsPrcID like @parm1 order by SlsPrcID
GO
