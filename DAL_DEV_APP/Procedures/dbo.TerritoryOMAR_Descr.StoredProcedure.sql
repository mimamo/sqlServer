USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[TerritoryOMAR_Descr]    Script Date: 12/21/2015 13:35:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[TerritoryOMAR_Descr] @parm1 varchar (10) as
    Select Descr from Territory where Territory = @parm1 order by Territory
GO
