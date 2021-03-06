USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[StubDetail_Type_TypeId_WrkLocID]    Script Date: 12/21/2015 16:01:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[StubDetail_Type_TypeId_WrkLocID] @parm1 varchar ( 1), @parm2 varchar ( 10), @parm3 varchar ( 6) as
       Select * from StubDetail
           where StubType      LIKE  @parm1
             and TypeId    LIKE  @parm2
             and WrkLocId  LIKE  @parm3
           order by TypeId, StubType DESC, WrkLocId
GO
