USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EarnDed_Type_WrkLocId_DEDId_CalYr]    Script Date: 12/21/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[EarnDed_Type_WrkLocId_DEDId_CalYr] @parm1 varchar ( 1), @parm2 varchar ( 6), @parm3 varchar ( 10), @parm4 varchar( 4) as
       Select * from EarnDed
           where EDType       LIKE  @parm1
             and WrkLocId   LIKE  @parm2
             and EarnDedId  LIKE  @parm3
             and CalYr = @parm4
       order by EarnDedId, EDType, WrkLocId
GO
