USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Piheader_All]    Script Date: 12/21/2015 13:35:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Piheader_All    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.Piheader_All    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc [dbo].[Piheader_All] @parm1 varchar ( 10) as
            Select * from piheader where PIID like @parm1
                order by PIID
GO
