USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BenEmp_TrnsBenId]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[BenEmp_TrnsBenId] @parm1 varchar ( 10) as
       Select * from BenEmp
           where TrnsBenId  =  @parm1
           order by EmpId,
                    BenId
GO
