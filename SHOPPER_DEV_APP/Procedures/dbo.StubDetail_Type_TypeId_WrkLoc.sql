USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[StubDetail_Type_TypeId_WrkLoc]    Script Date: 12/16/2015 15:55:35 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[StubDetail_Type_TypeId_WrkLoc] @parm1 varchar ( 1), @parm2 varchar ( 10), @parm3 varchar ( 6) as
       Select * from StubDetail
           where StubType      LIKE  @parm1
             and TypeId    LIKE  @parm2
             and WrkLocId  LIKE  @parm3
           order by Acct, Sub, ChkNbr, DocType, StubType DESC, TypeId, WrkLocId
GO
