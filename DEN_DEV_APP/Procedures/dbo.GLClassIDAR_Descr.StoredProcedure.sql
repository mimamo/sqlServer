USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[GLClassIDAR_Descr]    Script Date: 12/21/2015 14:06:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[GLClassIDAR_Descr] @parm1 varchar (4) as
    Select Descr from custglclass where GLClassID = @parm1 order by GLClassID
GO
