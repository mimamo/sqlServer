USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[W2StateLocal_EmpId_CalYr_]    Script Date: 12/21/2015 16:07:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[W2StateLocal_EmpId_CalYr_] @parm1 varchar ( 10), @parm2 varchar ( 4) as
       Select * from W2StateLocal
           where EmpId  LIKE  @parm1
             and CalYr  LIKE  @parm2
           order by EmpId        ,
                    CalYr        ,
                    State        ,
                    SLType     DESC,
                    EntityId
GO
