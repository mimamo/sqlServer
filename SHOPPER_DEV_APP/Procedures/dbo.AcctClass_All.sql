USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[AcctClass_All]    Script Date: 12/16/2015 15:55:09 ******/
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
