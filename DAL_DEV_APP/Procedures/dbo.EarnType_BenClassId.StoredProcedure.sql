USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EarnType_BenClassId]    Script Date: 12/21/2015 13:35:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[EarnType_BenClassId] @parm1 varchar ( 10) as
       Select * from EarnType
           where BenClassId  =  @parm1
           order by BenClassId
GO
