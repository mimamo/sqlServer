USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DDSetup_CpnyId]    Script Date: 12/21/2015 13:35:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[DDSetup_CpnyId] @parm1 varchar (10) as
    Select * from DDSetup
     where CpnyId like @parm1
    order by CpnyId
GO
