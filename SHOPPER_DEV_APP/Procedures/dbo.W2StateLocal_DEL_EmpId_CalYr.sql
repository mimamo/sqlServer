USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[W2StateLocal_DEL_EmpId_CalYr]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[W2StateLocal_DEL_EmpId_CalYr] @parm1 varchar ( 10), @parm2 varchar ( 4) as
       Delete w2statelocal from W2StateLocal
           where EmpId  LIKE  @parm1
             and CalYr  LIKE  @parm2
GO
