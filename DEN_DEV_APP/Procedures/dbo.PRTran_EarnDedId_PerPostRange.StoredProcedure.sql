USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_EarnDedId_PerPostRange]    Script Date: 12/21/2015 14:06:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRTran_EarnDedId_PerPostRange] @parm1 varchar ( 10), @parm2 varchar( 6), @parm3 varchar ( 6), @parm4 varchar (10) as
         Select PRTran.* From PRTran, Employee
                Where PRTran.EmpId = Employee.EmpId
                  and EarnDedId = @parm1
                  and TranType IN ('CK','HC','VC')
                  and Type_ = 'DW'
                  and Perpost between @parm2 and @parm3
                  and Rlsed <> 0
                  and APBatch = ''
                  and Employee.CpnyId = @parm4
         order by PRTran.CpnyId
GO
