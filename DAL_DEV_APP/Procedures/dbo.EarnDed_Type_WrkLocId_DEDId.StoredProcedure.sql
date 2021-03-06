USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EarnDed_Type_WrkLocId_DEDId]    Script Date: 12/21/2015 13:35:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[EarnDed_Type_WrkLocId_DEDId] @parm1 varchar ( 1), @parm2 varchar ( 6), @parm3 varchar ( 10) as
       Select * from EarnDed
           where EDType       LIKE  @parm1
             and WrkLocId   LIKE  @parm2
             and EarnDedId  LIKE  @parm3
       order by EarnDedId, EDType, WrkLocId
GO
