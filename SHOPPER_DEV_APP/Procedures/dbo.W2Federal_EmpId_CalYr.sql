USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[W2Federal_EmpId_CalYr]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[W2Federal_EmpId_CalYr] @parm1 varchar ( 10), @parm2 varchar ( 4) as
       Select * from W2Federal
           where EmpId  LIKE  @parm1
             and CalYr  LIKE  @parm2
           order by EmpId,
                    CalYr
GO
