USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AcctClass_All]    Script Date: 12/21/2015 14:34:04 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.AcctClass_All    Script Date: 4/7/98 12:38:58 PM ******/
Create Proc  [dbo].[AcctClass_All] @parm1 varchar ( 10) as
       Select * from AcctClass
           where ClassId LIKE  @parm1
           order by ClassId
GO
