USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ValEarnDed_EarnTypeId_DedId]    Script Date: 12/21/2015 13:35:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[ValEarnDed_EarnTypeId_DedId] @parm1 varchar ( 10), @parm2 varchar ( 10) as
       Select * from ValEarnDed
           where EarnTypeId  LIKE  @parm1
             and DedId       LIKE  @parm2
           order by EarnTypeId,
                    DedId
GO
