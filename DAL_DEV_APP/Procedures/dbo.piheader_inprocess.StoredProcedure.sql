USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[piheader_inprocess]    Script Date: 12/21/2015 13:35:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.piheader_inprocess    Script Date: 4/17/98 10:58:19 AM ******/
Create Procedure [dbo].[piheader_inprocess] @parm1 VarChar(10) As
    select * from piheader
    where piid like @parm1 and status = 'I'
    order by piid desc
GO
