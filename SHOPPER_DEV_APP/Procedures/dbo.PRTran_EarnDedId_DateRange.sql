USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_EarnDedId_DateRange]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRTran_EarnDedId_DateRange] @parm1 varchar ( 10), @parm2 smalldatetime, @parm3 smalldatetime, @parm4 varchar ( 10) as
         Select PRTran.* From PRTran, Employee
                Where PRTran.EmpId = Employee.EmpId
                  and EarnDedId = @parm1
                  and TranType IN ('CK','HC','VC')
                  and Type_ = 'DW'
                  and Trandate between @parm2 and @parm3
                  and Rlsed <> 0
                  and APBatch = ''
                  and Employee.CpnyId = @parm4
         order by PRTran.CpnyId
GO
