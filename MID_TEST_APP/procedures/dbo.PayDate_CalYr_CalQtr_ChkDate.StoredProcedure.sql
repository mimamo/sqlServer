USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PayDate_CalYr_CalQtr_ChkDate]    Script Date: 12/21/2015 15:49:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PayDate_CalYr_CalQtr_ChkDate] @parm1 varchar ( 4), @parm2 smallint, @parm3 smalldatetime, @parm4 varchar (10) as
       Select * from PayDate
           where CalYr   =  @parm1
             and CalQtr  =  @parm2
             and ChkDate =  @parm3
             and CpnyId  =  @parm4
           order by CalYr  ,
                    CalQtr ,
                    ChkDate,
                    CpnyId
GO
