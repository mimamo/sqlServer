USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PRDoc_BatNbr_Rlsed_]    Script Date: 12/21/2015 16:01:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[PRDoc_BatNbr_Rlsed_] @parm1 varchar ( 10), @parm2 smallint as
       Select * from PRDoc
           where BatNbr  =  @parm1
             and Rlsed   =  @parm2
           order by BatNbr ,
                    Acct   ,
                    Sub    ,
                    ChkNbr ,
                    DocType
GO
