USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ValEarnDed_EarnTypeId_DedId2]    Script Date: 12/21/2015 16:01:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[ValEarnDed_EarnTypeId_DedId2] @parm1 varchar ( 10), @parm2 varchar ( 10) as
       Select EarnTypeId, DedId  from ValEarnDed
           where EarnTypeId  LIKE  @parm1
             and DedId       LIKE  @parm2
           order by EarnTypeId,
                    DedId
GO
