USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ValWorkLocDed_WrkLocId_DedId]    Script Date: 12/21/2015 13:57:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[ValWorkLocDed_WrkLocId_DedId] @parm1 varchar ( 6), @parm2 varchar ( 10) as
       Select * from ValWorkLocDed
           where WrkLocId  LIKE  @parm1
             and DedId     LIKE  @parm2
           order by WrkLocId,
                    DedId
GO
