USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[W2Federal_DEL_EmpId_LE_CalYr]    Script Date: 12/21/2015 13:45:10 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[W2Federal_DEL_EmpId_LE_CalYr] @parm1 varchar ( 10), @parm2 varchar ( 4) as
       Delete w2federal from W2Federal
           where EmpId  LIKE  @parm1
             and CalYr  <=    @parm2
GO
