USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[W2StateLocal_DEL_EmpId_LECalYr]    Script Date: 12/21/2015 16:13:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[W2StateLocal_DEL_EmpId_LECalYr] @parm1 varchar ( 10), @parm2 varchar ( 4) as
       Delete w2statelocal from W2StateLocal
           where EmpId  LIKE  @parm1
             and CalYr  <=    @parm2
GO
