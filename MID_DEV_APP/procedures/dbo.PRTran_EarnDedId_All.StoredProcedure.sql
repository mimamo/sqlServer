USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_EarnDedId_All]    Script Date: 12/21/2015 14:17:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PRTran_EarnDedId_All] @parm1 varchar ( 10), @parm2 varchar( 10) as
         Select PRTran.* From PRTran, Employee
                Where PRTran.EmpId = Employee.EmpId
                  and EarnDedId = @parm1
                  and TranType IN ('CK','HC','VC')
                  and Type_ = 'DW'
                  and Rlsed <> 0
                  and APBatch = ''
                  and Employee.CpnyId = @parm2
         order by PRTran.CpnyId
GO
