USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeductCpny_DedId_CalYr_CpnyId]    Script Date: 12/21/2015 13:56:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[DeductCpny_DedId_CalYr_CpnyId] @parm1 varchar ( 10), @parm2 varchar ( 4) ,@parm3 varchar (10) as
       Select * from DeductCpny
           where DedId      =     @parm1
             and CalYr      =     @parm2
             and CpnyId    LIKE   @parm3
           order by CpnyId
GO
