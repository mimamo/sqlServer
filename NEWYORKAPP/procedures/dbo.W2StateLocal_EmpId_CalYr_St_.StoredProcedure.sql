USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[W2StateLocal_EmpId_CalYr_St_]    Script Date: 12/21/2015 16:01:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[W2StateLocal_EmpId_CalYr_St_] @parm1 varchar ( 10), @parm2 varchar ( 4), @parm3 varchar ( 3), @parm4 varchar ( 1), @parm5 varchar ( 10) as
       Select * from W2StateLocal
           where EmpId     =     @parm1
             and CalYr     =     @parm2
             and State     LIKE  @parm3
             and SLType      LIKE  @parm4
             and EntityId  LIKE  @parm5
           order by EmpId        ,
                    CalYr        ,
                    State        ,
                    SLType     DESC,
                    EntityId
GO
