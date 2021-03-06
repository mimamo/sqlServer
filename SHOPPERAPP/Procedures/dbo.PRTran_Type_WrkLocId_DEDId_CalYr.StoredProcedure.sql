USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_Type_WrkLocId_DEDId_CalYr]    Script Date: 12/21/2015 16:13:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRTran_Type_WrkLocId_DEDId_CalYr] @parm1 varchar ( 2), @parm2 varchar ( 6), @parm3 varchar ( 10), @parm4 varchar ( 4) as
       Select * from PRTran
           where Type_       LIKE  @parm1
             and WrkLocId   LIKE  @parm2
             and EarnDedId  LIKE  @parm3
             and CalYr = @parm4
           order by EarnDedId, Type_, WrkLocId
GO
