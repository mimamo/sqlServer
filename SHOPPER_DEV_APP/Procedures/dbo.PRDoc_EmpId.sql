USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_EmpId]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRDoc_EmpId] @parm1 varchar ( 10) as
       Select * from PRDoc
           where EmpId  =  @parm1
           order by EmpId
GO
