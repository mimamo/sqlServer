USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EarnDed_DEL_EmpId_LE_CalYr]    Script Date: 12/21/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[EarnDed_DEL_EmpId_LE_CalYr] @parm1 varchar ( 10), @parm2 varchar ( 4) as
       Delete earnded from EarnDed
           where EmpId   =  @parm1
             and CalYr  <=  @parm2
GO
