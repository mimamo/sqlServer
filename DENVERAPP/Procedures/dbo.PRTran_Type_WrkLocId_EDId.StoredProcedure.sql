USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRTran_Type_WrkLocId_EDId]    Script Date: 12/21/2015 15:43:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRTran_Type_WrkLocId_EDId] @parm1 varchar ( 2), @parm2 varchar ( 6), @parm3 varchar ( 10) as
       Select * from PRTran
           where Type_       LIKE  @parm1
             and WrkLocId   LIKE  @parm2
             and EarnDedId  LIKE  @parm3
           order by EmpId     ,
                    TimeShtFlg,
                    Rlsed     ,
                    Paid      ,
                    WrkLocId  ,
                    EarnDedId
GO
